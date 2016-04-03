class CreateTopicPaths < ActiveRecord::Migration
  def change
    create_table :topic_paths do |t|
      t.path :string
      t.count :integer

      t.timestamps null: false
    end
  end
end
