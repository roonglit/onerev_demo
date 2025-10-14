# This migration comes from campfire (originally 20251013142812)
class AddNameToCampfireUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :campfire_users, :name, :string, null: false, default: ""
  end
end
