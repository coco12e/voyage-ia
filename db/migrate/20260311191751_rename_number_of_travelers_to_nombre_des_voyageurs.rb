class RenameNumberOfTravelersToNombreDesVoyageurs < ActiveRecord::Migration[7.1]
  def change
    rename_column :trips, :number_of_travelers, :nombre_des_voyageurs
  end
end
