# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_30_083553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgrouting"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configuration", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.text "tag_key"
    t.text "tag_value"
    t.float "priority"
    t.float "maxspeed"
    t.float "maxspeed_forward"
    t.float "maxspeed_backward"
    t.string "force", limit: 1
    t.index ["tag_id"], name: "configuration_tag_id_key", unique: true
  end

  create_table "incidents", force: :cascade do |t|
    t.bigint "category_id"
    t.string "description"
    t.date "date"
    t.time "time"
    t.bigint "resolution_id"
    t.bigint "police_district_id"
    t.geography "position", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_incidents_on_category_id"
    t.index ["date"], name: "index_incidents_on_date"
    t.index ["police_district_id"], name: "index_incidents_on_police_district_id"
    t.index ["position"], name: "index_incidents_on_position"
    t.index ["resolution_id"], name: "index_incidents_on_resolution_id"
    t.index ["time"], name: "index_incidents_on_time"
  end

  create_table "planet_osm_line", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"line_string"}
    t.index ["way"], name: "planet_osm_line_way_idx", using: :gist
  end

  create_table "planet_osm_point", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "capital"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "ele"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.geometry "way", limit: {:srid=>3857, :type=>"st_point"}
    t.index ["way"], name: "planet_osm_point_way_idx", using: :gist
  end

  create_table "planet_osm_polygon", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"geometry"}
    t.geometry "way_lat_lon", limit: {:srid=>4326, :type=>"geometry"}
    t.index ["admin_level"], name: "index_planet_osm_polygon_on_admin_level"
    t.index ["amenity"], name: "polygon_amenities"
    t.index ["way"], name: "planet_osm_polygon_way_idx", using: :gist
  end

  create_table "planet_osm_roads", id: false, force: :cascade do |t|
    t.bigint "osm_id"
    t.text "access"
    t.text "addr:housename"
    t.text "addr:housenumber"
    t.text "addr:interpolation"
    t.text "admin_level"
    t.text "aerialway"
    t.text "aeroway"
    t.text "amenity"
    t.text "area"
    t.text "barrier"
    t.text "bicycle"
    t.text "brand"
    t.text "bridge"
    t.text "boundary"
    t.text "building"
    t.text "construction"
    t.text "covered"
    t.text "culvert"
    t.text "cutting"
    t.text "denomination"
    t.text "disused"
    t.text "embankment"
    t.text "foot"
    t.text "generator:source"
    t.text "harbour"
    t.text "highway"
    t.text "historic"
    t.text "horse"
    t.text "intermittent"
    t.text "junction"
    t.text "landuse"
    t.text "layer"
    t.text "leisure"
    t.text "lock"
    t.text "man_made"
    t.text "military"
    t.text "motorcar"
    t.text "name"
    t.text "natural"
    t.text "office"
    t.text "oneway"
    t.text "operator"
    t.text "place"
    t.text "population"
    t.text "power"
    t.text "power_source"
    t.text "public_transport"
    t.text "railway"
    t.text "ref"
    t.text "religion"
    t.text "route"
    t.text "service"
    t.text "shop"
    t.text "sport"
    t.text "surface"
    t.text "toll"
    t.text "tourism"
    t.text "tower:type"
    t.text "tracktype"
    t.text "tunnel"
    t.text "water"
    t.text "waterway"
    t.text "wetland"
    t.text "width"
    t.text "wood"
    t.integer "z_order"
    t.float "way_area"
    t.geometry "way", limit: {:srid=>3857, :type=>"line_string"}
    t.index ["way"], name: "planet_osm_roads_way_idx", using: :gist
  end

  create_table "pointsofinterest", primary_key: "pid", force: :cascade do |t|
    t.bigint "osm_id"
    t.bigint "vertex_id"
    t.bigint "edge_id"
    t.string "side", limit: 1
    t.float "fraction"
    t.float "length_m"
    t.text "tag_name"
    t.text "tag_value"
    t.text "name"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.geometry "new_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["osm_id"], name: "pointsofinterest_osm_id_key", unique: true
    t.index ["the_geom"], name: "pointsofinterest_the_geom_idx", using: :gist
  end

  create_table "police_districts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resolutions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ways", primary_key: "gid", force: :cascade do |t|
    t.bigint "osm_id"
    t.integer "tag_id"
    t.float "length"
    t.float "length_m"
    t.text "name"
    t.bigint "source"
    t.bigint "target"
    t.bigint "source_osm"
    t.bigint "target_osm"
    t.float "cost"
    t.float "reverse_cost"
    t.float "cost_s"
    t.float "reverse_cost_s"
    t.text "rule"
    t.integer "one_way"
    t.text "oneway"
    t.float "x1"
    t.float "y1"
    t.float "x2"
    t.float "y2"
    t.float "maxspeed_forward"
    t.float "maxspeed_backward"
    t.float "priority", default: 1.0
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"line_string"}
    t.index ["the_geom"], name: "ways_the_geom_idx", using: :gist
  end

  create_table "ways_vertices_pgr", force: :cascade do |t|
    t.bigint "osm_id"
    t.integer "eout"
    t.decimal "lon", precision: 11, scale: 8
    t.decimal "lat", precision: 11, scale: 8
    t.integer "cnt"
    t.integer "chk"
    t.integer "ein"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.index ["osm_id"], name: "ways_vertices_pgr_osm_id_key", unique: true
    t.index ["the_geom"], name: "ways_vertices_pgr_the_geom_idx", using: :gist
  end

  add_foreign_key "incidents", "categories"
  add_foreign_key "incidents", "police_districts"
  add_foreign_key "incidents", "resolutions"
  add_foreign_key "ways", "configuration", column: "tag_id", primary_key: "tag_id", name: "ways_tag_id_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "source", name: "ways_source_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "source_osm", primary_key: "osm_id", name: "ways_source_osm_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "target", name: "ways_target_fkey"
  add_foreign_key "ways", "ways_vertices_pgr", column: "target_osm", primary_key: "osm_id", name: "ways_target_osm_fkey"
end
