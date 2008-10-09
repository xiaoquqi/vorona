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
    t.string   "name",       :null => false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kpi_total", :id => false, :force => true do |t|
    t.datetime "datetime",                          :null => false
    t.string   "object",                            :null => false
    t.float    "cpu",                  :limit => 4
    t.float    "bhca",                 :limit => 4
    t.float    "msc_cap",              :limit => 4
    t.float    "vlr_total",            :limit => 4
    t.float    "vlr_total_alive",      :limit => 4
    t.float    "vlr_local",            :limit => 4
    t.float    "vlr_roaming",          :limit => 4
    t.float    "changtu_call",         :limit => 4
    t.float    "changtu_respon",       :limit => 4
    t.float    "netcon_rate",          :limit => 4
    t.float    "switch_response",      :limit => 4
    t.float    "switch_attempt",       :limit => 4
    t.float    "xunhu_rate",           :limit => 4
    t.float    "in_handover_attempt",  :limit => 4
    t.float    "in_handover_succ",     :limit => 4
    t.float    "out_handover_attempt", :limit => 4
    t.float    "out_handover_succ",    :limit => 4
    t.float    "handover_rate",        :limit => 4
    t.float    "mo_succ",              :limit => 4
    t.float    "mo_attempt",           :limit => 4
    t.float    "mt_succ",              :limit => 4
    t.float    "mt_attempt",           :limit => 4
    t.float    "locationupdate_att",   :limit => 4
    t.float    "locationupdate_succ",  :limit => 4
    t.float    "locationupdat_rate",   :limit => 4
    t.float    "sd_yongse",            :limit => 4
    t.float    "sd_shihu",             :limit => 4
    t.float    "sd_yongse_rate",       :limit => 4
    t.float    "tch_yichu_qiehuan",    :limit => 4
    t.float    "tch_shihu_qiehuan",    :limit => 4
    t.float    "tch_yongse_rate_qh",   :limit => 4
    t.float    "wx_jtl_qh",            :limit => 4
    t.float    "tch_yichu",            :limit => 4
    t.float    "tch_shihu",            :limit => 4
    t.float    "tch_yongse_rate",      :limit => 4
    t.float    "wx_jtl",               :limit => 4
    t.float    "tch_diaohua",          :limit => 4
    t.float    "tch_zhanyong",         :limit => 4
    t.float    "tch_diaohua_rate",     :limit => 4
    t.float    "badcell",              :limit => 4
    t.float    "over12cell",           :limit => 4
    t.float    "badcell_rate",         :limit => 4
    t.float    "hwl",                  :limit => 4
    t.float    "wx_liyonglv",          :limit => 4
    t.float    "tch",                  :limit => 4
    t.float    "switch_pdch",          :limit => 4
    t.float    "rf",                   :limit => 4
    t.float    "hwdhb",                :limit => 4
    t.float    "qiehuan_att",          :limit => 4
    t.float    "qiehuan_suc",          :limit => 4
    t.float    "qiehuan_rate",         :limit => 4
    t.float    "sd_diaohua",           :limit => 4
    t.float    "sd_att_sd_yichu",      :limit => 4
    t.float    "sd_diaohua_rate",      :limit => 4
    t.float    "wx_jieruxing",         :limit => 4
  end

  create_table "kpi_types", :force => true do |t|
    t.string "name",       :null => false
    t.string "table_name", :null => false
  end

  create_table "kpi_wuxian", :id => false, :force => true do |t|
    t.datetime "datetime", :null => false
    t.string   "object",   :null => false
  end

  create_table "kpis", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "human_name",   :null => false
    t.integer  "kpi_group_id", :null => false
    t.string   "kpi_type_id",  :null => false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "hashed_password", :null => false
    t.string   "fullname",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
