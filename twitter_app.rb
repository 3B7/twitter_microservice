require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'rufus-scheduler'
require 'twitter'
require 'redis'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'byebug'

require_relative './models/init.rb'
require_relative 'lib/workers/tweet_worker.rb'

class TwitterApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::CrossOrigin
  register Sinatra::ConfigFile
  config_file './config/config.yml'

  scheduler = Rufus::Scheduler.new
  TOPICS = ["healthcare", "nasa", "open source"]

  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['CONSUMER_KEY'] || settings.consumer_key
    config.consumer_secret     = ENV['CONSUMER_SECRET'] || settings.consumer_secret
    config.access_token        = ENV['ACCESS_TOKEN'] ||settings.access_token
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET'] ||settings.access_token_secret
  end
  
  # Search is rate limited at 180 queries per 15 minute window.
  # https://dev.twitter.com/rest/public/rate-limiting
  scheduler.every '15m' do
    puts "cron task @ #{Time.now}"
    TOPICS.each do |topic|
      @@client.search(topic).take(25).each do |tweet|
        TweetWorker.perform_async tweet.attrs, topic
      end
    end
  end
  
  get '/api/search' do
    cross_origin allow_origin: :any,
      allow_methods:      [:get],
      allow_credentials:  false,
      max_age:            "1728000"
    
      @user = PartnerUser.find_by(uuid: params[:token] )
      if @user.try(:approved?)
        content_type :json
        response = {
          data: Tweet.where(topic: params[:topic]).last(10)
        }
        response.to_json
      else
        halt 401, "Not authorized\n"
      end
  end

  get "/api/status" do
    cross_origin allow_origin: :any,
      allow_methods:      [:get],
      allow_credentials:  false,
      max_age:            "1728000"

      @user = PartnerUser.find_by(uuid: params[:token] )
      if @user 
        content_type :json
        response = {
          data: "Your status is: #{@user.status}. If you have any questions or concerns please contact info@nooneishere.com"
        }
        response.to_json
      else
        halt 401, "Not authorized\n"
      end
  end

  get '/request_access' do
    erb :request_access
  end

  post "/request" do
    pu = PartnerUser.new(
      name: params["partner_user"]["name"], 
      url: params["partner_user"]["url"],
      email: params["partner_user"]["email"]
    )

    if pu.save
      "Request Received. We'll be in contact shortly. Your access token is #{pu.uuid}. Store it in a safe place. Check api/status endpoint for updates."
    else
      "Could not submit the request. Following errors were found: #{pu.errors.full_messages.to_sentence}. Try again."
    end
  end

end