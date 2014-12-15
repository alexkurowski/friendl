class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.boolean :is_reply, default: false
      t.boolean :no_reply, default: false
      t.references :from, index: true
      t.string :key
      t.integer :sent, default: 0
      t.string :subject, default: ""
      t.text :body, default: ""

      t.timestamps
    end
    add_index :emails, :key
  end
end
