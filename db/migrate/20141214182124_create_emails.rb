class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :from, index: true
      t.string :key
      t.string :subject, default: ""
      t.text :body, default: ""
      t.boolean :is_reply, default: false
      t.boolean :no_reply, default: false
      t.integer :sent, default: 0
      t.boolean :bad, default: false

      t.timestamps
    end
    add_index :emails, :key
  end
end
