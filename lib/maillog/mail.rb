require "active_record"
require "forwardable"
require "mail"

module Maillog
  class Mail < ActiveRecord::Base
    extend Forwardable

    self.table_name = "maillogs"

    delegate [:from, :to, :cc, :bcc, :reply_to, :subject, :body] => :parsed

    def deliver
      begin
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
      @parsed ||= ::Mail::Message.new(message)
    end
  end
end
