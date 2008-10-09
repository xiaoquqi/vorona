namespace :import do  
  desc "Import KPI Group" 
  task :kpi_group => [:environment] do

    unless ENV.include?("file")
      raise "usage: rake file=<kpi group.csv>"
    end
    puts File.exists?(ENV["file"])
    puts ENV["file"]

    unless File.exists?(ENV["file"])
      raise "Can not find File #{ENV["file"]}"
    end

    group_name = ''
    File.open(ENV["file"]).each do |line|
      line = line.chomp
      puts line
      #CPU	CPU负荷	cpu	1
      items = line.split(',')
      if items.size == 4
        group_name = items[0] unless items[0].blank?
        kpi_human_name = items[1] unless items[1].blank?
        unless items[2].blank?
          kpi_name = items[2]
        else
          puts "Ignore human name = #{kpi_human_name}"
          next
        end
        kpi_type_id = items[3]
        puts "group_name = #{group_name} #{kpi_name} #{kpi_human_name} #{kpi_type_id}"
        # group
        group = KpiGroup.find_by_name(group_name)
        group_id = ''
        group_id = group.id unless group.nil?
        if group.nil?
          puts "find new group ----------->#{group_name}"
          new_group = KpiGroup.new
          new_group.name = group_name
          new_group.created_at = Time.now
          new_group.updated_at = Time.now
          new_group.save
          group_id = new_group.id
        end
        puts "group_id = #{group_id}"
        # kpi
        kpi = Kpi.find_by_name(kpi_name)
        if kpi.nil?
          new_kpi = Kpi.new
          new_kpi.name = kpi_name
          new_kpi.human_name = kpi_human_name
          new_kpi.kpi_group_id = group_id
          #puts "kpi_type_id=#{kpi_type_id}"
          #new_kpi.kpi_type_id = kpi_type_id
          new_kpi.created_at = Time.now
          new_kpi.updated_at = Time.now
          new_kpi.save
        end
      else
        puts "Error Line: #{line}"
      end
    end

  end
end
