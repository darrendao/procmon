module Procmon
  module Notifiers
    class Email < Notifier
      def self.notify(notification, target=nil)
        if target.nil? && !defined?(NOTIFICATION_TARGET)
          warn "Don't know where to send the notification"
        elsif target.nil?
          target = NOTIFICATION_TARGET
        end

        puts "Need to email #{target} the following"
        puts notification
      end
    end
  end
end
