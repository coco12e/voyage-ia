class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trips, dependent: :destroy
  has_many :conversations, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
