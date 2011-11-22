class AddDescToUsers < ActiveRecord::Migration
  def change
    add_column :users, :backgroundcolor, :string
    add_column :users, :bio, :string
    add_column :users, :location, :string
    add_column :users, :url, :string
  end
end
