module Maillog
  module CallbackRegistration
    def self.included(klass)
      klass.class_eval do
        after_action :set_maillog_callbacks
      end
    end

    def after_create_maillog(&block)
      @maillog_callbacks ||= []
      @maillog_callbacks.push(block)
    end

    private
    def set_maillog_callbacks
      if @maillog_callbacks
        mail.instance_variable_set(:@maillog_callbacks, @maillog_callbacks)
      end
    end
  end
end
