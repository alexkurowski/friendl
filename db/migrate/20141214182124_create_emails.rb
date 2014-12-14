class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.boolean :is_reply, default: false
      t.boolean :no_reply, default: false
      t.references :from, index: true
      t.string :key
      t.integer :sent
      t.text :body

      t.timestamps
    end
    add_index :emails, :key
  end
end
