class AddOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :photo, :string
    remove_column :users, :twitter
    remove_column :users, :facebook
  end
end
