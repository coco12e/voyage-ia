class Trip < ApplicationRecord
  belongs_to :user

  validates :name, :destination, :number_of_travelers, presence: true
  validates :number_of_travelers, numericality: { only_integer: true, greater_than: 0 }
end
