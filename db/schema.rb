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

ActiveRecord::Schema[8.1].define(version: 2026_03_09_052714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "group_type", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["group_type"], name: "index_groups_on_group_type"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "count"
    t.datetime "created_at", null: false
    t.string "device_id"
    t.datetime "recorded_at"
    t.datetime "updated_at", null: false
  end

  create_table "user_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "device_id", null: false
    t.bigint "group_id", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id", "group_id"], name: "index_user_groups_on_device_id_and_group_id", unique: true
    t.index ["device_id"], name: "index_user_groups_on_device_id"
    t.index ["group_id"], name: "index_user_groups_on_group_id"
  end

  add_foreign_key "user_groups", "groups"
end
