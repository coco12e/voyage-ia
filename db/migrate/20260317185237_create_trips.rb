class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.integer :travellers_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
