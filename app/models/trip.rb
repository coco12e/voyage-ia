class Trip < ApplicationRecord
  belongs_to :user
  has_many :conversations

  # On crée un alias pour que le code accepte le nom français
  alias_attribute :nombre_des_voyageurs, :number_of_travelers
end
