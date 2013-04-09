class AddOwnerIdToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :owner_id, :integer
  end
end
