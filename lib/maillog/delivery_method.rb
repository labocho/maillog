require "mail/check_delivery_params"

module Maillog
  class DeliveryMethod
    attr_accessor :settings
    include ::Mail::CheckDeliveryParams

    def initialize(settings = {})
      @settings = settings.dup
    end

    def deliver!(mail)
      smtp_envelope_from, smtp_envelope_to, message = check_delivery_params(mail)
      log = log_mail(message)
      log.deliver
    end

    private
    def log_mail(message)
      Maillog.model.create!(message: message, state: "delivered")
    end
  end
end
