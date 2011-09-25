class AddColorToComments < ActiveRecord::Migration
  def change
    add_column :comments, :color, :string
  end
end
