class AddBackgroundtileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :backgroundtile, :boolean
  end
end
