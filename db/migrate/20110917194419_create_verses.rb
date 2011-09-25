class CreateVerses < ActiveRecord::Migration
  def change
    create_table :verses do |t|
      t.integer :bible_id
      t.integer :book_id
      t.string :book_name
      t.integer :chapter
      t.integer :number
      t.text :text

      t.timestamps
    end
  end
end
