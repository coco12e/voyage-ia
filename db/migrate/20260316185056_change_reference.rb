class ChangeReference < ActiveRecord::Migration[8.1]
  def change
    remove_reference :chats, :trips
    add_reference :chats, :trip, foreign_key: true
  end
end
