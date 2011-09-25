class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :twitter
      t.string :facebook
      t.boolean :admin

      t.timestamps
    end
  end
end
