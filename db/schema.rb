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

ActiveRecord::Schema.define(version: 2021_09_01_010645) do

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "status"
    t.decimal "dprice"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "name", "dprice"], name: "index_products_on_user_id_and_name_and_dprice"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "sales_points", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id", null: false
    t.integer "status"
    t.decimal "lat"
    t.decimal "lon"
    t.integer "capacity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lat", "lon", "user_id"], name: "index_sales_points_on_lat_and_lon_and_user_id"
    t.index ["user_id"], name: "index_sales_points_on_user_id"
  end

  create_table "sales_product_relations", force: :cascade do |t|
    t.integer "sales_point_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "price"
    t.index ["product_id"], name: "index_sales_product_relations_on_product_id"
    t.index ["sales_point_id"], name: "index_sales_product_relations_on_sales_point_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "products", "users"
  add_foreign_key "sales_points", "users"
  add_foreign_key "sales_product_relations", "products"
  add_foreign_key "sales_product_relations", "sales_points"
end
