class CreateTopicPairs < ActiveRecord::Migration
  def change
    create_table :topic_pairs do |t|
      t.string :pair
      t.integer :count
      t.integer :refresh

      t.timestamps null: false
    end
  end
end
