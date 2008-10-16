class Chart

  DATE_FORMAT = "%Y-%m-%d %H:%M"

  LINE = 'LINE'
  BAR3D = 'BAR3D'

  COLORS = ["#FF0000", "#00FF00", "#0000FF", "#FF00FF", "#00FFFF", "#FFFF00", "#F0F8FF", "#70DB93", "#5C3317", "#9F5F9F"]

  def initialize()
  end
  # Params is request kpi id
  #def initialize(kpi_ids, date, object_name)
  #  @kpi_ids = kpi_ids
  #  @date = date
  #  @start_time = "#{@date} 00:00:00"
  #  @end_time = "#{@date} 23:00:00"
  #  @object_name = object_name
  #  @kpis = Kpi.find(:all, :conditions => ["id in (?)", @kpi_ids])
  #  @kpi_human_name = @kpis.collect{|record|record.human_name}.join(' - ')

  #  @g = Graph.new
  #  @g.set_bg_color('#FFFFFF')
  #  @g.title("#{@date} #{@object_name} #{@kpi_human_name}", '{color: #7E97A6; font-size: 20; text-align: center}')
  #  @g.set_x_axis_color('#818D9D', '#F0F0F0' )
  #  @g.set_y_axis_color( '#818D9D', '#ADB5C7' )
  #  @g.y_right_axis_color('#164166' )
  #  # Size/Color/orientation/Step/Grid_color
  #  @g.set_x_label_style(10, '#164166', 2, 1, '#818D9D')
  #  # Tip
  #  @g.set_tool_tip('#tip#')

  #  # Line Setting
  #  @line_width = 2
  #  @line_color = ['#818D9D', '#9933CC']
  #  # Line dot
  #  @dot_size = 4
  #  # Title Style
  #  @title_size = 10
  #  # Legend color
  #  @x_lengend_color = '#164166'
  #  @x_lengend_size = 20
  #  @y_lengend_color = '#164166'
  #  @y_lengend_size = 20

  #end

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

  # if color_number > defined color size
  # Calculate color average between defined color
  def self.generate_colors(color_number)
    colors = Array.new
    if color_number < COLORS.size
      colors = COLORS[0..(color_number - 1)]
    else
      # Put all color into generate color first
      # Then begin to calculate color
      colors = COLORS.collect{|x|x}
      for i in (COLORS.size + 1)..color_number
        # Range
        start_color_pos = i.modulo(COLORS.size) - 1
        RAILS_DEFAULT_LOGGER.debug("pos: #{i} modulo #{COLORS.size} = #{i.modulo(COLORS.size)} #{start_color_pos}")
        start_r, start_g, start_b = hex_to_rgb(COLORS[start_color_pos])
        end_r, end_g, end_b = hex_to_rgb(COLORS[start_color_pos + 1])
        RAILS_DEFAULT_LOGGER.debug("Start: #{COLORS[start_color_pos]}")
        RAILS_DEFAULT_LOGGER.debug("Start: #{start_r} #{start_g} #{start_b}")
        RAILS_DEFAULT_LOGGER.debug("End: #{COLORS[start_color_pos + 1]}")
        RAILS_DEFAULT_LOGGER.debug("End: #{end_r} #{end_g} #{end_b}")
        split_number = i.div(COLORS.size) + 1
        r = (start_r + end_r)/split_number
        g = (start_g + end_g)/split_number
        b = (start_b + end_b)/split_number
        RAILS_DEFAULT_LOGGER.debug("Generate: #{r} #{g} #{b}")
        color = "\##{r.to_s(16)}#{g.to_s(16)}#{b.to_s(16)}"
        colors.push(color)
        RAILS_DEFAULT_LOGGER.debug("source: #{color}")
      end
    end
    return colors
  end
private
  # Convert hex color to RGB 
  def self.hex_to_rgb(hex_color)
    if hex_color =~ /#(..)(..)(..)/
      r = $1.hex
      g = $2.hex
      b = $3.hex
      return r, g, b
    else
      return false
    end
  end 
  # Return integer max setting
  def integer_max(number)
    # Add for float number
    number = number.to_i
    size = number.to_s.size - 1
    first = number.to_s.split('').first.to_i + 1
    return first * (10**size)
  end

end
