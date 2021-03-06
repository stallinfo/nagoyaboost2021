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

ActiveRecord::Schema.define(version: 2022_02_16_064011) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.integer "stock"
    t.index ["product_id"], name: "index_sales_product_relations_on_product_id"
    t.index ["sales_point_id"], name: "index_sales_product_relations_on_sales_point_id"
  end

  create_table "userchecklist_transactions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "userchecklist_id", null: false
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_userchecklist_transactions_on_user_id"
    t.index ["userchecklist_id", "user_id"], name: "index_userchecklist_transactions_on_userchecklist_id_and_user_id"
    t.index ["userchecklist_id"], name: "index_userchecklist_transactions_on_userchecklist_id"
  end

  create_table "userchecklists", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "created_at"], name: "index_userchecklists_on_id_and_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "apikey"
    t.integer "gender"
    t.integer "age"
    t.integer "shoptime"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "products", "users"
  add_foreign_key "sales_points", "users"
  add_foreign_key "sales_product_relations", "products"
  add_foreign_key "sales_product_relations", "sales_points"
  add_foreign_key "userchecklist_transactions", "userchecklists"
  add_foreign_key "userchecklist_transactions", "users"
end
