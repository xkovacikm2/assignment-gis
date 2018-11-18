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

ActiveRecord::Schema.define(version: 2018_11_18_110932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["resolution_id"], name: "index_incidents_on_resolution_id"
    t.index ["time"], name: "index_incidents_on_time"
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

  add_foreign_key "incidents", "categories"
  add_foreign_key "incidents", "police_districts"
  add_foreign_key "incidents", "resolutions"
end
