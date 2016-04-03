class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.string :hyperlink
      t.integer :start_count
      t.integer :end_count

      t.timestamps null: false
    end
  end
end
