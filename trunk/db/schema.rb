# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081009022418) do

  create_table "kpi_groups", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kpi_total", :primary_key => "object", :force => true do |t|
    t.datetime "datetime", :null => false
    t.float    "cpu"
  end

  create_table "kpi_types", :force => true do |t|
    t.string "name",       :default => "", :null => false
    t.string "table_name", :default => "", :null => false
  end

  create_table "kpi_wuxian", :primary_key => "object", :force => true do |t|
    t.datetime "datetime"
    t.integer  "sd_yongse"
  end

  create_table "kpis", :force => true do |t|
    t.string   "name",         :default => "", :null => false
    t.string   "human_name",   :default => "", :null => false
    t.integer  "kpi_group_id",                 :null => false
    t.string   "kpi_type_id",  :default => "", :null => false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_names", :id => false, :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "rel_helper", :force => true do |t|
    t.string "platform",    :limit => 0,   :default => "", :null => false
    t.string "description", :limit => 256, :default => "", :null => false
    t.string "train",       :limit => 0,   :default => "", :null => false
    t.string "coreid",      :limit => 0,   :default => "", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",            :default => "", :null => false
    t.string   "hashed_password", :default => "", :null => false
    t.string   "fullname",        :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
