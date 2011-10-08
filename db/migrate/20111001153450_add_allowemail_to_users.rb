class AddAllowemailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allowemail, :boolean
  end
end
