module Maillog
  module ActualDelivery
    module_function
    def deliver(mail)
      mail.instance_variable_set(:@delivery_method, delivery_method())
      mail.deliver
    end

    def delivery_method
      method = Maillog.mailer.delivery_method
      if method == :maillog
        raise "Maillog.mailer.delivery_method must not be :maillog"
      end
      settings = Maillog.mailer.send("#{method}_settings")
      ActionMailer::Base.delivery_methods[method].new(settings)
    end
  end
end
