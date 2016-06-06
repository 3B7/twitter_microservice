# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160522212051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "partner_users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "url"
    t.string   "uuid"
    t.datetime "revoked_at"
    t.datetime "approved_at"
  end

  create_table "tweets", force: :cascade do |t|
    t.datetime "created_at"
    t.string   "t_id"
    t.string   "full_text"
    t.text     "hashtags"
    t.string   "user_id"
    t.string   "user_name"
    t.string   "screen_name"
    t.integer  "followers_count"
    t.string   "profile_image_url"
    t.string   "topic"
  end

  add_index "tweets", ["t_id"], name: "index_tweets_on_t_id", unique: true, using: :btree
  add_index "tweets", ["topic"], name: "index_tweets_on_topic", using: :btree

end
