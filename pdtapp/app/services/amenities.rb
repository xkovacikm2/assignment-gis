class Amenities
  def self.get_amenities_types
    sql = <<-SQL
      SELECT DISTINCT amenity FROM planet_osm_polygon
    SQL

    result = ActiveRecord::Base.connection.execute(sql)
    result.values.flatten.compact
  end

  def self.get_amenities_crimes(type, crime, date_from, date_to, distance)
    sql = <<-SQL
      SELECT ST_AsGeoJSON(poly.way_lat_lon) AS coords,
             poly.name AS poly_name, 
             COUNT(i.*) AS occurences,
             json_agg(i.description) AS descriptions,
             ST_AsGeoJSON(ST_Centroid(poly.way_lat_lon)) AS centroid
      FROM planet_osm_polygon AS poly
      JOIN incidents AS i ON ST_DWithin(poly.way_lat_lon, i.position, #{distance})
      JOIN categories AS cat ON i.category_id = cat.id
      WHERE amenity LIKE '#{type}'
        AND cat.name LIKE '#{crime}'
        AND i.date >= '#{date_from}'
        AND i.date <= '#{date_to}'
      GROUP BY poly.way_lat_lon, poly.name
    SQL

    result = ActiveRecord::Base.connection.execute(sql)

    amenities = result.values.map do |geojson|
      amenity = {type: :feature}

      amenity[:geometry] = JSON.parse geojson[0]
      amenity[:properties] = {
        name: geojson[1],
        occurences: geojson[2],
        descriptions: JSON.parse(geojson[3]).join(',')
      }

      amenity
    end

    occurences = amenities.map {|a| a[:properties][:occurences]}
    max = occurences.max
    min = occurences.min

    crime_gravity = result.values.map do |geojson|
      amenity = {type: :feature}

      amenity[:geometry] = JSON.parse geojson[4]
      amenity[:properties] = {
        gravity: (geojson[2] - min + 1.0) / (max - min + 1.0)
      }

      amenity
    end

    sql = <<-SQL
      SELECT ST_AsGeoJSON(ST_Centroid((SELECT ST_Union(ST_GeomFromGeoJSON(t.coords)) FROM (#{sql}) AS t)))
    SQL

    result = ActiveRecord::Base.connection.execute(sql) rescue nil
    centroid = JSON.parse(result.values[0][0])['coordinates'] rescue nil

    return amenities, crime_gravity, centroid
  end
end