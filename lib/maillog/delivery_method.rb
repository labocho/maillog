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
      bcc = mail.bcc.blank? ? nil : mail.bcc.join(", ")
      log = log_mail(message, bcc)
      log.deliver
    end

    private
    def log_mail(message, bcc)
      Maillog.model.create!(message: message, bcc: bcc, state: "delivered")
    end
  end
end

