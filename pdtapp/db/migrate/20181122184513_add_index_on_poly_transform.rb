class AddIndexOnPolyTransform < ActiveRecord::Migration[5.2]

  # ST_Transform index too huge, so separate column created instead
  def up
    sql = <<-SQL
      ALTER TABLE planet_osm_polygon
      ADD COLUMN way_lat_lon geometry(Geometry, 4326)
    SQL

    execute sql

    sql = <<-SQL
      UPDATE planet_osm_polygon
      SET way_lat_lon = ST_Transform(way, 4326)
    SQL

    execute sql

    <<-SQL
      CREATE INDEX planet_osm_polygon_way_lon_lat_idx
      ON planet_osm_polygon (way_lon_lat);
    SQL

    execute sql
  end
end
