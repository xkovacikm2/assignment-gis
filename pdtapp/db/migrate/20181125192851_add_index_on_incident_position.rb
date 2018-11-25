class AddIndexOnIncidentPosition < ActiveRecord::Migration[5.2]
  def change
    add_index :incidents, :position
  end
end
