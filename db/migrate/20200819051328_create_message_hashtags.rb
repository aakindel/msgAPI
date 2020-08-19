class CreateMessageHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :message_hashtags do |t|
      t.integer :hash_count
      t.references :hashtag, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
