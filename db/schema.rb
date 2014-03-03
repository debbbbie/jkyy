# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140303105121) do

  create_table "orders", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "yuyue_type",             null: false
    t.string   "yuyue_at",               null: false
    t.integer  "price"
    t.integer  "status"
    t.integer  "referee_id"
    t.integer  "referee_fee"
    t.string   "valid_code",  limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_infos", force: true do |t|
    t.integer  "user_id"
    t.string   "idcard",      limit: 20
    t.string   "qq",          limit: 20
    t.string   "name",        limit: 20
    t.boolean  "sex"
    t.date     "birth"
    t.string   "reg_addr",    limit: 80
    t.string   "mobile",      limit: 20
    t.string   "cont_addr",   limit: 80
    t.string   "che_xing",    limit: 20
    t.date     "valid_start"
    t.date     "valid_end"
    t.string   "school",      limit: 50
    t.string   "flow_no",     limit: 30
    t.string   "status",      limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",       limit: 20
    t.string   "account",    limit: 20
    t.string   "pwd",        limit: 20
    t.string   "mobile",     limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
