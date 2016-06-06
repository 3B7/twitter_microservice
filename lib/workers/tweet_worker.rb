class TweetWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform payload, topic
    if Tweet.find_by(t_id: payload[:id]).nil?
      
      Tweet.create!(
        created_at: Time.parse(payload["created_at"]),
        t_id: payload["id_str"],
        full_text: payload["text"],
        hashtags: payload["entities"]["hashtags"].collect{|h| h["text"]},
        user_id: payload["user"]["id"],
        user_name: payload["user"]["name"],
        screen_name: payload["user"]["screen_name"],
        followers_count: payload["user"]["followers_count"], 
        profile_image_url: payload["user"]["profile_image_url_https"],
        topic: topic
      )

    end
  end
end