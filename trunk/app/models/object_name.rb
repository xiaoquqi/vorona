class ObjectName < ActiveRecord::Base

  def self.names
    return find(:all, :order => "name").collect{|record|record.name}
  end

end
