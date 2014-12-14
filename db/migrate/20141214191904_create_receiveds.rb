class CreateReceiveds < ActiveRecord::Migration
  def change
    create_table :receives, id: false do |t|
      t.references :user, index: true
      t.references :email, index: true

      t.timestamps
    end
  end
end
