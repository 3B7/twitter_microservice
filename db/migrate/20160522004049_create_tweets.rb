class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.datetime :created_at 
      t.string   :t_id 
      t.string   :full_text
      t.text     :hashtags
      t.string   :user_id
      t.string   :user_name
      t.string   :screen_name
      t.integer  :followers_count
      t.string   :profile_image_url
      t.string   :topic
    end

    add_index :tweets, :t_id, unique: true
    add_index :tweets, :topic
  end
end
