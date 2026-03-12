class RenameNombreDesVoyageursToNumberOfTravelers < ActiveRecord::Migration[7.1]
  def change
    rename_column :trips, :"nombre des voyageurs", :number_of_travelers
  end
end
