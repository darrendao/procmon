module Procmon
  module ProcessConditions
    class CpuUsage < ProcessCondition
      def initialize(options = {})
        super(options)
        @below = options[:below]
        @above = options[:above]
        if @below && @above && @below < @above
          raise "Invalid range for mem check condition"
        elsif @below.nil? && @above.nil?
          raise "Invalid range for mem check condition"
        end
      end

      def run(pid)
        System.cpu_usage(pid).to_f
      end

      def check(value)
        if @below && @above
          value < @below && value > @above
        elsif @below
          value < @below 
        elsif @above
          value > @above
        end
      end

      def description
        ret = "Cpu usage is "
        conditions = {}
        conditions[:below] = @options[:below] if @options[:below]
        conditions[:above] = @options[:above] if @options[:above]
        ret += conditions.inspect
      end
    end
  end
end
