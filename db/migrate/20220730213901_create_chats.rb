class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :messages_count
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
    add_index :chats, :number, unique: true
  end
end
