class AddSystemPromptToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :system_prompt, :text
  end
end
