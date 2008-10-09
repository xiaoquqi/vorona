class CreateKpis < ActiveRecord::Migration
  def self.up
    create_table :kpis do |t|
      t.column :name, :string, :null => false
      t.column :human_name, :string, :null => false
      t.column :kpi_group_id, :integer, :null => false
      # Identify kpi type msc or bsc
      t.column :kpi_type_id, :string, :null => false
      t.column :order, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :kpis
  end
end
