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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :force => true do |t|
    t.string "name", :null => false
    t.string "slug", :null => false
  end

  add_index "categories", ["name"], :name => "UNIQ_FF3A7B975E237E06", :unique => true

  create_table "jobs", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "job_type",                     :null => false
    t.string   "company",                      :null => false
    t.string   "logo"
    t.string   "url"
    t.string   "position"
    t.string   "location",                     :null => false
    t.string   "description",  :limit => 4000, :null => false
    t.string   "how_to_apply", :limit => 4000, :null => false
    t.boolean  "is_public",                    :null => false
    t.boolean  "is_activated",                 :null => false
    t.string   "email",                        :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at"
    t.datetime "expires_at",                   :null => false
  end

  add_index "jobs", ["category_id"], :name => "UNIQ_C395A61812469DE2"
  add_index "jobs", ["user_id"], :name => "user_id"

end
