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

ActiveRecord::Schema.define(version: 20141214191904) do

  create_table "emails", force: true do |t|
    t.integer  "from_id"
    t.string   "key"
    t.string   "subject",    default: ""
    t.text     "body",       default: ""
    t.boolean  "is_reply",   default: false
    t.boolean  "no_reply",   default: false
    t.integer  "sent",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["from_id"], name: "index_emails_on_from_id"
  add_index "emails", ["key"], name: "index_emails_on_key"

  create_table "receives", id: false, force: true do |t|
    t.integer  "user_id"
    t.integer  "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "receives", ["email_id"], name: "index_receives_on_email_id"
  add_index "receives", ["user_id"], name: "index_receives_on_user_id"

  create_table "users", force: true do |t|
    t.string   "address"
    t.boolean  "banned",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
