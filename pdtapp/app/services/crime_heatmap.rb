class CrimeHeatmap
  def self.get_heatmap(date_from, date_to, crime)
    sql = <<-SQL
      SELECT ST_AsGeoJSON(i.position), pd.name
      FROM incidents AS i
      JOIN categories AS cat ON cat.id = i.category_id
      JOIN police_districts AS pd ON pd.id = i.police_district_id
      WHERE cat.name LIKE '#{crime}'
        AND i.date >= '#{date_from}'
        AND i.date <= '#{date_to}'
    SQL

    results = ActiveRecord::Base.connection.execute sql

    results.values.map do |result|
      {
        type: :feature,
        geometry: JSON.parse(result[0]),
        properties: {
          text: result[1]
        }
      }
    end
  end
end