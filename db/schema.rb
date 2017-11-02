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

ActiveRecord::Schema.define(version: 20170728042708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "cases", force: :cascade do |t|
    t.integer   "service_request_id",                                                             null: false
    t.string    "category",                                                                       null: false
    t.string    "service_subtype"
    t.string    "service_details"
    t.string    "status",                                                                         null: false
    t.string    "status_notes"
    t.string    "agency"
    t.string    "address"
    t.geography "location",           limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.datetime  "case_requested",                                                                 null: false
    t.datetime  "case_updated"
    t.string    "source"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.index ["case_requested"], name: "index_cases_on_case_requested", using: :btree
    t.index ["category"], name: "index_cases_on_category", using: :btree
    t.index ["location"], name: "index_cases_on_location", using: :gist
    t.index ["service_request_id"], name: "index_cases_on_service_request_id", unique: true, using: :btree
    t.index ["status"], name: "index_cases_on_status", using: :btree
  end

end
