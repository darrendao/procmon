module Procmon
  module ProcessConditions
    class ProcessCondition
      def initialize(options = {})
        @options = options
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
