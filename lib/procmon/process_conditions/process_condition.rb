module Procmon
  module ProcessConditions
    class ProcessCondition
      attr_reader :actions
      def initialize(options = {})
        @options = options
        @actions = options[:actions]
      end

      def run(pid)
        raise "Implement in subclass!"
      end

      def check(value)
        raise "Implement in subclass!"
      end

      def format_value(value)
        value
      end

      def description
        raise "Implement in subclass!"
      end
    end
  end
end
