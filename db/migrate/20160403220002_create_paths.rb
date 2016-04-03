class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :path
      t.integer :count

      t.timestamps null: false
    end
  end
end
