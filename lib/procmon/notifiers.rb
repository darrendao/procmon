require 'procmon/notifiers/notifier'

Dir["#{File.dirname(__FILE__)}/notifiers/*.rb"].each do |file|
  require file
end
