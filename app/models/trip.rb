class Trip < ApplicationRecord
  belongs_to :user
  has_many :conversations

  # Fait le lien entre le nom demandé par ton prof et le nom réel en base
  alias_attribute :nombre_des_voyageurs, :number_of_travelers
end
