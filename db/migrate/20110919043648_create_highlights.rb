class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.integer :user_id
      t.integer :verse_id
      t.string :color

      t.timestamps
    end
  end
end
