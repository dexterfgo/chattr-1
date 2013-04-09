class CreateAdminJoinTable < ActiveRecord::Migration
  def change
    create_table :admins_channels, :id => false do |t|
      t.integer :user_id
      t.integer :channel_id
    end
  end
end
