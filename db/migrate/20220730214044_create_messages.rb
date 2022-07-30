class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :number
      t.text :body
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
    add_index :messages, :number, unique: true
  end
end
