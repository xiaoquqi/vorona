class CreateKpiTypes < ActiveRecord::Migration
  def self.up
    create_table :kpi_types do |t|
      t.column :name, :string, :null => false
      t.column :table_name, :string, :null => false
    end
    KpiType.create(:name => "交换指标", :table_name => "kpi_total")
    KpiType.create(:name => "无线指标", :table_name => "kpi_wuxian")
  end

  def self.down
    drop_table :kpi_types
  end
end
