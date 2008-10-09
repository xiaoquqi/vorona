class CreateObjectNames < ActiveRecord::Migration
  def self.up
    execute "create view object_names as
	          select distinct object as name, 1 as kpi_type_id from kpi_total
                  union
                  select distinct object as name, 2 as kpi_type_id from kpi_wuxian" 
  end

  def self.down
    drop_table :object_names
  end
end
