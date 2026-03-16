class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.integer :number_of_travelers

      t.timestamps
    end
  end
end
