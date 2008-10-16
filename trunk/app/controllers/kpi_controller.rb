class KpiController < ApplicationController
  layout "standard"

  def initialize
    @page_title = "KPI"
    @kpi_groups = KpiGroup.find(:all)
    # Select object names
    @all_object_names = ObjectName.names 
    @already_select_object_names = Array.new
    @can_select_object_names = @all_object_names
    # Select kpi id
    @kpi_ids = Array.new
    # Chart number
    @single_show = true
    @multiple_show = true 
    # error message
    @error = nil
    # graphs
    @graphs = Array.new
  end

  # Action
  def index
    redirect_to :action => "show"
  end

  # color test
  def color
    # Input source color, and genrated color number
    @colors = Chart.generate_colors(3)
  end

  def show
    initialize_session
  end

  def generate_kpi_chart
    # Check argument
    @error = check_arguments(params)
    logger.debug(@error)
    # if pass the checking generate kpi
    if @error.blank?
      case
      when session[:time_type] == "24h" then generate_24h_kpi_chart(params)
      when session[:time_type] == "same_hour" then generate_same_hour_kpi_chart(params)
      when session[:time_type] == "sequence" then generate_sequence_kpi_chart(params)
      end
    end
    render :layout => false, :partial => "show_graph"
  end

  # Page Changed Method
  # trigger by kpi tree
  def kpi_tree_changed
    @selected_kpis = nil
    @kpi_ids = Array.new
    # initialize select object names
    @already_select_object_names = (session[:object_names].nil?)? Array.new : session[:object_names] 
    @can_select_object_names = @all_object_names - @already_select_object_names
    unless params[:kpi].nil?
      @kpi_ids = params[:kpi].collect{ |key, value| key }
      session[:kpi_id] = @kpi_ids
      @selected_kpis = Kpi.find_all_by_id(@kpi_ids, :include => "kpi_group")
      if @kpi_ids.size > 1
        # if one more kpi selected, clear object names
        @already_select_object_names = Array.new
        @can_select_object_names = @all_object_names
      end
    else
      session[:kpi_id] = nil
    end
    # Set chart number
    set_chart_number
  end 

  # Trigger by click object name
  def object_name_changed
    logger.debug("kpi_id = #{session[:kpi_id].size}") unless session[:kpi_id].nil?
    # Select left box
    unless params[:can_select_object_name].nil?
      @already_select_object_names = (session[:object_names].nil?)? Array.new : session[:object_names]
      unless session[:kpi_id].nil?
        # One more kpi can only select one object
        if session[:kpi_id].size > 1
          @already_select_object_names = Array.new
          session[:object_names] = nil
        end
      end
      params[:can_select_object_name].each{|object_name|@already_select_object_names.push(object_name)}
      @can_select_object_names = @all_object_names - @already_select_object_names
      session[:object_names] = @already_select_object_names
    end
    # Select right box
    unless params[:already_select_object_name].nil?
      @already_select_object_names = (session[:object_names].nil?)? Array.new : session[:object_names]
      params[:already_select_object_name].each{|object_name|@already_select_object_names.delete(object_name)}
      @can_select_object_names = @all_object_names - @already_select_object_names
      session[:object_names] = @already_select_object_names
    end
    # Set chart number
    set_chart_number
  end 

  # Tigger by Time type changed
  def time_type_changed
    session[:time_type] = params[:time_type]
    # Set chart number
    set_chart_number
  end 

private
   def initialize_session
    session[:kpi_id] = nil
    session[:object_names] = nil
    session[:time_type] = '24h'
    session[:chart_num] = 'single_chart'
    session[:chart_type] = 'line'
  end 

   def set_chart_number
     time_type = session[:time_type].to_s
     object_names = (session[:object_names].nil?)? 0 : session[:object_names].size
     kpi_id = (session[:kpi_id].nil?)? 0 : session[:kpi_id].size
     logger.debug("time_type:#{time_type} #{object_names} #{kpi_id}")
     if (time_type == 'same_hour' or time_type == 'sequence') and kpi_id < 2 and object_names < 2
       @multiple_show = false
     end
   end

   def check_arguments(params)
     errors = Array.new
     errors.push("请从左侧选择KPI指标") if session[:kpi_id].blank?
     errors.push("请选择网元") if session[:object_names].blank?
     return errors.join("; ")
   end

   # Generate chart
   def generate_24h_kpi_chart(params)
     if session[:kpi_id].size > 1
       # Multiple KPI, only can select sinlge Object
     else
       # Single KPI
       if session[:object_names].size > 1
         # Multiple Object
       else
         # Single Object
         if session[:chart_num] == "single_chart"
           # Single Chart
         else
           # Multiple Chart, loop by Date
         end
       end
     end
   end

   def generate_same_hour_kpi_chart(params)
     if session[:kpi_id].size > 1
       # Multiple KPI, only can select sinlge Object
     else
       # Single KPI
       if session[:object_names].size > 1
         # Multiple Object
       else
         # Single Object
       end
     end
   end

   def generate_sequence_kpi_chart(params)
     if session[:kpi_id].size > 1
       # Multiple KPI, only can select sinlge Object
     else
       # Single KPI
       if session[:object_names].size > 1
         # Multiple Object
       else
         # Single Object
       end
     end
   end

end