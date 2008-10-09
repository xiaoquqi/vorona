namespace :chart do
  desc 'Install the Open Flash Chart components'
  task :install do
    require 'fileutils'

    FileUtils.rm_rf(File.join(File.join(RAILS_ROOT, 'public', 'javascripts', 'open_flash_chart')))
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'public', 'javascripts', 'open_flash_chart'),
            File.join(RAILS_ROOT, 'public', 'javascripts'))
  end
end
