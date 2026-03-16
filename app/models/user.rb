class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trips, dependent: :destroy
  has_many :conversations, dependent: :destroy
end
