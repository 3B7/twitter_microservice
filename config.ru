# config.ru (run with rackup)
# rackup -p 4567
# be sidekiq -r ./twitter_app.rb

require './twitter_app.rb'

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'admin' && password == 'password'
  end

  run Sidekiq::Web
end

run Rack::URLMap.new('/' => TwitterApp)