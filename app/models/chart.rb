class Chart

  DATE_FORMAT = "%Y-%m-%d %H:%M"

  LINE = 'LINE'
  BAR3D = 'BAR3D'
  # Params is request kpi id
  def initialize(kpi_ids, date, object_name)
    @kpi_ids = kpi_ids
    @date = date
    @start_time = "#{@date} 00:00:00"
    @end_time = "#{@date} 23:00:00"
    @object_name = object_name
    @kpis = Kpi.find(:all, :conditions => ["id in (?)", @kpi_ids])
    @kpi_human_name = @kpis.collect{|record|record.human_name}.join(' - ')

    @g = Graph.new
    @g.set_bg_color('#FFFFFF')
    @g.title("#{@date} #{@object_name} #{@kpi_human_name}", '{color: #7E97A6; font-size: 20; text-align: center}')
    @g.set_x_axis_color('#818D9D', '#F0F0F0' )
    @g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    @g.y_right_axis_color('#164166' )
    # Size/Color/orientation/Step/Grid_color
    @g.set_x_label_style(10, '#164166', 2, 1, '#818D9D')
    # Tip
    @g.set_tool_tip('#tip#')

    # Line Setting
    @line_width = 2
    @line_color = ['#818D9D', '#9933CC']
    # Line dot
    @dot_size = 4
    # Title Style
    @title_size = 10
    # Legend color
    @x_lengend_color = '#164166'
    @x_lengend_size = 20
    @y_lengend_color = '#164166'
    @y_lengend_size = 20

  end

  # Get kpi value by kpi_id and kpi_name
  def get_kpi_value
    select_kpi_name = @kpis.collect{|record|record.name}
    # Multiply Hash structure
    # start_time => {kpi_name1 => kpi_value, 
    #                kpi_name2 => kpi_value}
    @kpi_data_hash = Hash.new
    KpiTotal.find(:all,
                 :select => "datetime, #{select_kpi_name.join(',')}",
    :conditions => ["datetime >= ? and datetime <= ? and object = ?",@start_time, @end_time, @object_name],
                 :order => "datetime asc").each do |record|
      start_time = record.datetime.strftime(DATE_FORMAT)
      @kpi_data_hash[start_time] = record.attributes
    end
  end

  # Set chart basic information
  def set_line_chart
    # Get kpi value
    get_kpi_value
    # Set chart basic
    @g.set_x_labels(@kpi_data_hash.keys.sort)
    # Create line, Cycle by kpi_id
    # Get y and y_right max value
    # Set data and X/Y Lengend
    # Use first kpi human name as y left lengend
    # Use second kpi human name as y right legend
    y_max = 0
    y_right_max = 0
    count_kpi = 1
    @kpis.each do |kpi| #request kpi
      line = LineDot.new(@line_width, @dot_size, @line_color[count_kpi - 1])
      line.key(kpi.human_name, @title_size)
      @kpi_data_hash.sort.each do |start_time, kpi_hash| #request kpi data
        line.add_data_tip(kpi_hash[kpi.name], "#{start_time} #{kpi.human_name}:#{kpi_hash[kpi.name]}")
        if count_kpi == 1
          y_max = kpi_hash[kpi.name] if kpi_hash[kpi.name] > y_max
        end
        if count_kpi == 2
          y_right_max = kpi_hash[kpi.name] if kpi_hash[kpi.name] > y_right_max
        end
      end # end @kpi_data_hash.sort.each
      @g.data_sets << line
      @g.set_y_max(integer_max(y_max))

      if y_right_max != 0
        @g.set_y_right_max(integer_max(y_right_max))
        @g.attach_to_y_right_axis(2)
      end
      count_kpi = count_kpi + 1
    end # end @kpis.each

    @g.set_y_label_steps(5)

  end # end set_line_chart

  def make_chart
    # Basic Setting for chart
    set_line_chart
    return @g.render
  end

  def self.generate_colors(source_color, color_number)
    colors = Array.new
    colors.push(source_color)
    for i in 1..color_number
      RAILS_DEFAULT_LOGGER.debug("--> #{source_color}")
      source_color =~ /#(..)(..)(..)/ 
      r = $1.hex
      g = $2.hex
      b = $3.hex
      RAILS_DEFAULT_LOGGER.debug("#{r}, #{g}, #{b}")
      r = ((r + 1) > 255)? (255 - r) : (r + 1)
      g = ((g + 5) > 255)? (255 - g) : (g + 5)
      b = ((b + 10) > 255)? (255 - b) : (b + 10)
      source_color = "\##{r.to_s(16)}#{g.to_s(16)}#{b.to_s(16)}"
      colors.push(source_color)
      RAILS_DEFAULT_LOGGER.debug("source: #{source_color}")
    end
    return colors
  end
private
  # Return integer max setting
  def integer_max(number)
    # Add for float number
    number = number.to_i
    size = number.to_s.size - 1
    first = number.to_s.split('').first.to_i + 1
    return first * (10**size)
  end

end
