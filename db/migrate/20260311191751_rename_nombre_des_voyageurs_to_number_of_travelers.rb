class RenameNombreDesVoyageursToNumberOfTravelers < ActiveRecord::Migration[7.1]
  def change
    rename_column :trips, :nombre_des_voyageurs, :number_of_travelers
  end
end
