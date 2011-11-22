class AddBackgroundToUsers < ActiveRecord::Migration
  def change
    add_column :users, :backgroundurl, :string
  end
end
