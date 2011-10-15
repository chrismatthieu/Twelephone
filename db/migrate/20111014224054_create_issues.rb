class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.float :offer
      t.integer :status

      t.timestamps
    end
  end
end
