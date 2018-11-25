class CreateIncidents < ActiveRecord::Migration[5.2]
  def change
    create_table :incidents do |t|
      t.references :category, foreign_key: true, index: true
      t.string :description
      t.date :date, index: true
      t.time :time
      t.references :resolution, foreign_key: true
      t.references :police_district, foreign_key: true, index: true
      t.st_point :position, geographic: true
      t.timestamps
    end
  end
end
