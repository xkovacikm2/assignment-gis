require 'csv'

puts 'Loading reports file'
reports_path = Rails.root.join 'db', 'police-department-incidents.csv'
csv_text = File.read reports_path
puts 'Reports file loaded'

puts 'Seeding database:'
idx = 1

CSV.parse(csv_text, headers: true).each do |row|
  row_data = row.to_hash

  category = Category.find_or_create_by! name: row_data['Category'].downcase
  district = PoliceDistrict.find_or_create_by! name: row_data['PdDistrict'].downcase
  resolution = Resolution.find_or_create_by! name: row_data['Resolution'].downcase

  Incident.create! category: category, description: row_data['Descript'].downcase, date: row_data['Date'],
                  time: row_data['Time'], police_district: district, resolution: resolution,
                  position: "POINT(#{row_data['X']} #{row_data['Y']})"

  puts idx if idx % 1000 == 0
  idx += 1
end
