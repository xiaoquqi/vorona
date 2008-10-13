class KpiController < ApplicationController
  layout "standard"

  def initialize
    @page_title = "KPI"
    @kpi_groups = KpiGroup.find(:all)
    @all_object_names = ObjectName.names 
    # Chart number
    @single_show = true
    @multiple_show = true 
  end

  def index
    redirect_to :action => "show"
  end

  def show
    initialize_session
    @already_select_object_names = Array.new
    @kpi_ids = Array.new
    @can_select_object_names = @all_object_names
  end

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
    end
    # Set chart number
    set_chart_number
  end 

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

   # Time type changed
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
end
