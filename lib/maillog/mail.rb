require "active_record"
require "forwardable"
require "mail"

module Maillog
  class Mail < ActiveRecord::Base
    extend Forwardable

    self.table_name = "maillogs"

    delegate [:from, :to, :cc, :bcc, :reply_to, :subject, :body] => :parsed

    # waiting time (sec) before deliver
    def wait
      0
    end

    def deliver
      begin
        update!(state: "processing")
        sleep wait
        ActualDelivery.deliver(parsed)
        update!(state: "delivered")
      rescue SocketError, Net::OpenTimeout, Net::SMTPAuthenticationError, Net::SMTPFatalError
        update!(
          state: "failed",
          exception_class_name: $!.class.to_s,
          exception_message: $!.message,
        )
      end
    end

    def parsed
      @parsed ||= begin
        parsed = ::Mail::Message.new(message)
        parsed.bcc = self[:bcc]
        parsed
      end
    end
  end
end
