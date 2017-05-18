

class User < ApplicationRecord
  has_many :ledgers
  has_many :stocks, through: :ledgers


end
