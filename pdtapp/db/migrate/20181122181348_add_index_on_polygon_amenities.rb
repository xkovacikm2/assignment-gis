class AddIndexOnPolygonAmenities < ActiveRecord::Migration[5.2]
  def up
    sql = <<-SQL
      CREATE INDEX polygon_amenities
      ON planet_osm_polygon (amenity)
    SQL

    execute sql
  end
end
