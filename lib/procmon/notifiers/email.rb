require 'net/smtp'

module Procmon
  module Notifiers
    class Email < Notifier
      def self.notify(notification, target=nil)
        if target.nil? && !defined?(NOTIFICATION_TARGET)
          warn "Don't know where to send the notification"
        elsif target.nil?
          target = NOTIFICATION_TARGET
        end

        message = <<MESSAGE_END
From: Procmon <procmon>
To: #{target}
Subject: Procmon notification

#{notification}
MESSAGE_END

        Net::SMTP.start('localhost') do |smtp|
          smtp.send_message message, 'procmon', target
        end
      end
    end
  end
end
