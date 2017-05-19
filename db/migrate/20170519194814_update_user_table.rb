class UpdateUserTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :password_salt
    remove_column :users, :password_hash
    remove_column :users, :password_digest

  end
end
