class CreateKpiGroups < ActiveRecord::Migration
  def self.up
    create_table :kpi_groups do |t|
      t.column :name, :string, :null => false
      t.column :order, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :kpi_groups
  end
end
