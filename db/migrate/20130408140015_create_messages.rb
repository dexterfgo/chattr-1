class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :user_id
      t.integer :channel_id
      t.integer :reply_to

      t.timestamps
    end
  end
end
