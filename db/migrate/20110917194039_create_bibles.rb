class CreateBibles < ActiveRecord::Migration
  def change
    create_table :bibles do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
