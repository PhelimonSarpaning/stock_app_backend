class UpdateStockColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :stocks, :symbol
  end
end
