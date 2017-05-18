class CreateLedgers < ActiveRecord::Migration[5.0]
  def change
    create_table :ledgers do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
