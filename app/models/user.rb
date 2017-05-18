
require 'bcrypt'

class User < ApplicationRecord
  has_many :ledgers
  has_many :stocks, through: :ledgers


  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
