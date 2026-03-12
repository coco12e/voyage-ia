class Trip < ApplicationRecord
  belongs_to :user
  has_many :conversations, dependent: :destroy

  # Remplacez :number_of_travelers par le VRAI nom de la colonne dans votre db/schema.rb
  alias_attribute :nombre_des_voyageurs, :number_of_travelers
end
