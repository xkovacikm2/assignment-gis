class PolicePath
  def self.get_police_call(date_from, date_to, location)
    nearest_crime_sql = find_nearest_crime_sql date_from, date_to, location
    nearest_police_station_sql = find_nearest_police_sql nearest_crime_sql
    nearest_vertex_to_crime_sql = nearest_vertex_to_geom_sql nearest_crime_sql
    nearest_vertex_to_police_sql = nearest_vertex_to_geom_sql nearest_police_station_sql
    nearest_cafe_sql = find_nearest_cafe_sql nearest_crime_sql, nearest_police_station_sql
    nearest_vertex_to_cafe_sql = nearest_vertex_to_geom_sql nearest_cafe_sql

    police_to_coffee = dijkstra nearest_vertex_to_police_sql, nearest_vertex_to_cafe_sql
    coffee_to_crim = dijkstra nearest_vertex_to_cafe_sql, nearest_vertex_to_crime_sql

    routes_sql = <<-SQL
      SELECT ST_AsGeoJSON(ST_Union(line.the_geom)), string_agg(DISTINCT line.name, '<br>')
      FROM ways AS line, (#{police_to_coffee}) AS pc_dji, (#{coffee_to_crim}) AS cc_dji
      WHERE line.gid = pc_dji.edge
         OR line.gid = cc_dji.edge
    SQL

    routes = ActiveRecord::Base.connection.execute routes_sql

    police_path = routes.values.map do |route|
      {
        type: :feature,
        geometry: JSON.parse(route[0]),
        properties: {
          text: route[1]
        }
      }
    end

    crime = ActiveRecord::Base.connection.execute(find_nearest_crime_sql date_from, date_to, location, 'ST_AsGeoJSON(i.position), i.description, res.name')
    police = ActiveRecord::Base.connection.execute(find_nearest_police_sql nearest_crime_sql, 'ST_AsGeoJSON(ST_Centroid(poly.way_lat_lon)), poly.name')
    cafe = ActiveRecord::Base.connection.execute(find_nearest_cafe_sql nearest_crime_sql, nearest_police_station_sql, 'ST_AsGeoJSON(ST_Centroid(poly.way_lat_lon)), poly.name')
    points = []

    points.push({
      type: :feature,
      geometry: JSON.parse(crime.values[0][0]),
      properties: {
        text: "#{crime.values[0][1]} => #{crime.values[0][2]}",
        color: '#f00'
      }
    })

    points.push({
      type: :feature,
      geometry: JSON.parse(police.values[0][0]),
      properties: {
        text: police.values[0][1],
        color: '#00f'
      }
    })

    points.push({
      type: :feature,
      geometry: JSON.parse(cafe.values[0][0]),
      properties: {
        text: cafe.values[0][1],
        color: '#0f0'
      }
    })

    return police_path, points
  end

  def self.nearest_vertex_to_geom_sql(geom)
    <<-SQL
      SELECT v.id
      FROM ways_vertices_pgr as v
      ORDER BY v.the_geom <-> (#{geom})
      LIMIT 1
    SQL
  end

  def self.find_nearest_crime_sql(date_from, date_to, location, select = 'i.position')
    <<-SQL
      SELECT #{select}
      FROM incidents AS i
      JOIN categories AS cat ON cat.id = i.category_id
      JOIN resolutions AS res ON res.id = i.resolution_id
      WHERE i.date >= '#{date_from}'
        AND i.date <= '#{date_to}'
      ORDER BY i.position <-> ST_GeomFromGeoJSON('#{location}')
      LIMIT 1
    SQL
  end

  def self.find_nearest_police_sql(nearest_crime_sql, select = 'poly.way_lat_lon')
    <<-SQL
      SELECT #{select}
      FROM planet_osm_polygon AS poly
      WHERE amenity LIKE 'police'
      ORDER BY poly.way_lat_lon <-> (#{nearest_crime_sql})
      LIMIT 1
    SQL
  end

  def self.find_nearest_cafe_sql(crime, police, select = 'poly.way_lat_lon')
    <<-SQL
      SELECT #{select}
      FROM planet_osm_polygon AS poly
      WHERE amenity LIKE 'cafe'
      ORDER BY ((poly.way_lat_lon <-> (#{crime})) + (poly.way_lat_lon <-> (#{police})))
      LIMIT 1
    SQL
  end

  def self.dijkstra(from, to)
    <<-SQL
      SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, source, target, length AS cost FROM ways',
        (#{from}), (#{to}), directed := false
      )
    SQL
  end
end