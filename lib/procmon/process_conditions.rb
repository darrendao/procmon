module Procmon
  module ProcessConditions
    def self.[](name)
      const_get(name.to_s.camelcase)
    end
  end
end

require "procmon/process_conditions/process_condition"
Dir["#{File.dirname(__FILE__)}/process_conditions/*.rb"].each do |pc|
  require pc
end
