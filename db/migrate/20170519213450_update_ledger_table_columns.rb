class UpdateLedgerTableColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :ledgers, :stock_id
    add_column :ledgers, :symbol, :string
  end
end
