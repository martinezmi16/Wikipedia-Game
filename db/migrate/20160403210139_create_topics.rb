class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :start_count
      t.string :end_count
      t.string :integer

      t.timestamps null: false
    end
  end
end
