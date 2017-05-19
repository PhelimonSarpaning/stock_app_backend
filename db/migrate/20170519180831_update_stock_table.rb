class UpdateStockTable < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :symbol, :string
    add_column :stocks, :exchange, :string
    remove_column :stocks, :price
    add_column :ledgers, :price, :decimal

  end
end
