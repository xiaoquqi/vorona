#--
# Copyright (c) 2008 Martin Xu
#

module OpenFlashChart
  module Helper        
    def open_flash_chart(width, height, url, background_color='#FFFFFF')
      uuid = UUID.random_create.to_s
      <<doc
<div id="#{uuid}">
  Open Flash Chart.
</div>

<script type="text/javascript">
   var so = new SWFObject("/javascripts/open_flash_chart/open-flash-chart.swf", "Open Flash Chart", "#{width}", "#{height}", "9", "#{background_color}");
   so.addVariable("variable","true");
   so.addVariable("data", "#{url}");
   so.addParam("allowScriptAccess", "sameDomain");
   so.write("#{uuid}");
</script>
doc
    end

    alias chart open_flash_chart
  end
end

include ActionView
module ActionView::Helpers::AssetTagHelper
  alias_method :old_javascript_include_tag, :javascript_include_tag

  def javascript_include_tag(*sources)
    main_sources, application_source = [], []
    if sources.include?(:chart)
      sources.delete(:chart)
      sources.push('open_flash_chart/swfobject')
    end
    unless sources.empty?
      main_sources = old_javascript_include_tag(*sources).split("\n")
      application_source = main_sources.pop if main_sources.last.include?('application.js')
    end
    [main_sources.join("\n"), application_source].join("\n")
  end
end