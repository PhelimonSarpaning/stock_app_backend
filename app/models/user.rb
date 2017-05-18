class User < ApplicationRecord
  has_many :ledgers
  has_many :stocks, through: :ledgers
  has_secure_password
end
