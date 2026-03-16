class Trip < ApplicationRecord
  belongs_to :user
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
  validates :destination, presence: true
  validates :number_of_travelers, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
