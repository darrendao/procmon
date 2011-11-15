module Procmon
  class ProcessNotification
    def initialize(process, check)
      hostname = `hostname`.strip
      @msg = ""
      @msg += "Hostname: #{hostname}" + "\n"
      @msg += "Process: #{process.name}" + "\n"
      @msg += "Description: #{check.description}"
    end
    def to_s
      @msg
    end
  end
end
