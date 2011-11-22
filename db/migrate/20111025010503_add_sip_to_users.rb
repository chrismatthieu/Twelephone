class AddSipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sip, :string
    add_column :users, :presence, :datetime
  end
end
