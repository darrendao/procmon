module Procmon
  module ProcessConditions
    class MemUsage < ProcessCondition
      MB = 1024 ** 2
      FORMAT_STR = "%d%s"
      MB_LABEL = "MB"
      KB_LABEL = "KB"

      attr_reader :actions

      def initialize(options = {})
        @options = options
        @actions = options[:actions]
        @below = options[:below]
        @above = options[:above]
        if @below && @above && @below < @above
          raise "Invalid range for mem check condition"
        elsif @below.nil? && @above.nil?
          raise "Invalid range for mem check condition"
        end
      end

      def run(pid)
        # rss is on the 5th col
        System.memory_usage(pid).to_f
      end

      def check(value)
        if @below && @above
          value.kilobytes < @below && value.kilobytes > @above
        elsif @below
          value.kilobytes < @below 
        elsif @above
          value.kilobytes > @above
        end
      end

      def format_value(value)
        if value.kilobytes >= MB
          FORMAT_STR % [(value / 1024).round, MB_LABEL]
        else
          FORMAT_STR % [value, KB_LABEL]
        end
      end

      def description
        ret = "Memory usage is "
        conditions = {}
        conditions[:below] = @options[:below] if @options[:below]
        conditions[:above] = @options[:above] if @options[:above]
        ret += conditions.inspect
      end
    end
  end
end
