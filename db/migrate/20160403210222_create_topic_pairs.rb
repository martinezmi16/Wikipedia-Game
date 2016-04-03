class CreateTopicPairs < ActiveRecord::Migration
  def change
    create_table :topic_pairs do |t|
      t.topic_pair :string

      t.timestamps null: false
    end
  end
end
