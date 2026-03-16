class ChangeColumnInTrip < ActiveRecord::Migration[8.1]
  def change
    remove_column :trips, :number_of_travelers
    add_column :trips, :number_of_travelers, :integer
  end
end
