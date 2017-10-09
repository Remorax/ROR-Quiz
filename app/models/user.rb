class User < ApplicationRecord
  validates_uniqueness_of :name
  has_secure_password
  validates :password, length: { minimum: 8, maximum: 20 }, on: :create
end
