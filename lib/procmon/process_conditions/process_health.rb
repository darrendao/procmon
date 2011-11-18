module Procmon
  module ProcessConditions
    class ProcessHealth < ProcessCondition
      def initialize(options = {})
        super(options)
        @status = options[:status]
        if @status != "up" and @status != "down"
          raise "Don't know what to do for process_health check. You need to specify :status => \"down\" or :status => \"up\""
        end
      end

      def run(pid)
        return false if pid.nil?
        System.pid_alive?(pid)
      end

      def check(value)
        !(value ^ (@status == "up"))
      end

      def description
        "Checking to see if is_up = #{@is_up}"
      end
    end
  end
end
