class UpdateLedgerTable < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :watched, :boolean
  end
end
