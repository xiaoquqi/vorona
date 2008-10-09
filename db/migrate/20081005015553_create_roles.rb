class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string, :null => false
    end
    Role.create(:name => '管理员')
    Role.create(:name => '用户')
  end

  def self.down
    drop_table :roles
  end
end
