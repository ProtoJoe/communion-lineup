# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_06_005235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lineups", id: :serial, force: :cascade do |t|
    t.date "service_date"
    t.string "position_1"
    t.string "position_2"
    t.string "position_3"
    t.string "position_4"
    t.string "position_5"
    t.string "position_6"
    t.string "position_7"
    t.string "position_8"
    t.string "position_9"
    t.string "position_10"
    t.string "position_11"
    t.string "position_12"
    t.string "position_13"
    t.string "position_14"
    t.string "position_15"
    t.string "position_16"
    t.string "position_17"
    t.string "position_18"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "position_19"
  end

end
