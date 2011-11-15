module Procmon
  module Notifiers
    class Notifier
      def self.notify
        raise "Implement in subclass!"
      end
    end
  end
end
