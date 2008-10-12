class KpiController < ApplicationController
  layout "standard"

  def initialize
    @page_title = "KPI"
    @kpi_groups = KpiGroup.find(:all)
    @all_object_names = ObjectName.names 
  end

  def index
    redirect_to :action => "show"
  end

  def show
    initialize_session
    @already_select_object_names = Array.new
    @kpi_ids = Array.new
    @can_select_object_names = @all_object_names
    @single_show = true
    @multiple_show = true 
  end

  # trigger by kpi tree
  def kpi_tree_changed
    @selected_kpis = nil
    @kpi_ids = Array.new
    unless params[:kpi].nil?
      @kpi_ids = params[:kpi].collect{ |key, value| key }
      session[:kpi_id] = @kpi_ids
      @selected_kpis = Kpi.find_all_by_id(@kpi_ids, :include => "kpi_group")
    end
  end 

private
   def initialize_session
    session[:kpi_id] = nil
    session[:object_names] = nil
    session[:time_type] = '24h'
    session[:chart_num] = 'single_chart'
    session[:chart_type] = 'line'
  end 
end
