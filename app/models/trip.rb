class Trip < ApplicationRecord
  belongs_to :user
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
  validates :destination, presence: true
  validates :nombre_des_voyageurs, presence: true, numericality: { only_integer: true, greater_than: 0 }

  alias_attribute :nombre_des_voyageurs, :number_of_travelers
end
