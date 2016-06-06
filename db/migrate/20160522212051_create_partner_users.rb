class CreatePartnerUsers < ActiveRecord::Migration
  def change
    create_table :partner_users do |t|
      t.string      :name
      t.string      :email
      t.string      :url
      t.string      :uuid
      t.datetime    :revoked_at
      t.datetime    :approved_at
    end
  end
end
