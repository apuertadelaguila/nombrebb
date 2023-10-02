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

ActiveRecord::Schema[7.0].define(version: 2023_09_27_211658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bebes", force: :cascade do |t|
    t.string "nombre"
    t.integer "prioridad"
    t.integer "sexo"
    t.integer "puntuacion", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by"
  end

  create_table "enfrentamientos", force: :cascade do |t|
    t.integer "bebe_1_id", null: false
    t.integer "bebe_2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["bebe_1_id"], name: "index_enfrentamientos_on_bebe_1_id"
    t.index ["bebe_2_id"], name: "index_enfrentamientos_on_bebe_2_id"
    t.index ["user_id"], name: "index_enfrentamientos_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "views", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_views_on_email", unique: true
    t.index ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true
  end

  create_table "votacions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bebe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bebe_id"], name: "index_votacions_on_bebe_id"
    t.index ["user_id"], name: "index_votacions_on_user_id"
  end

  add_foreign_key "enfrentamientos", "users"
  add_foreign_key "votacions", "bebes"
  add_foreign_key "votacions", "users"
end
