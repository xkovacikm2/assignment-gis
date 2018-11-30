class AddIndexOnOsmAdminLevel < ActiveRecord::Migration[5.2]
  def change
    add_index :planet_osm_polygon, :admin_level
  end
end
