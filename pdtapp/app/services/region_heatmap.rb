class RegionHeatmap
  def self.district_crime_map
    polygon_sql = <<-SQL
      SELECT ST_AsGeoJSON(poly.way_lat_lon), poly.name, COUNT(i.*)
      FROM planet_osm_polygon AS poly
      LEFT JOIN incidents AS i ON ST_Contains(poly.way_lat_lon, i.position::geometry)
      WHERE poly.admin_level IS NOT NULL
        AND (i.date >= '2004/01/01' OR i.date IS NULL)
        AND (i.date <= '2005/01/01' OR i.date IS NULL)
      GROUP BY poly.way_lat_lon, poly.name
    SQL

    results = ActiveRecord::Base.connection.execute polygon_sql

    max = results.values.map{|result| result[2]}.max
    min = results.values.map{|result| result[2]}.min

    results.values.map do |result|
      {
        type: :feature,
        geometry: JSON.parse(result[0]),
        properties: {
          text: "#{result[1]}: #{result[2]}",
          color: set_scale(max, min, result[2])
        }
      }
    end
  end

  def self.set_scale(max, min, value)
    idx = (value - min)/(max-min) * color_scale.size
    idx = idx - 1 unless idx == 0
    color_scale[idx]
  end

  def self.color_scale
    %w(#fc8d59 #7f0000)
  end
end