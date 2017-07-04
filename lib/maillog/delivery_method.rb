require "mail/check_delivery_params"

module Maillog
  class DeliveryMethod
    attr_accessor :settings

    # >= 2.5.5, >= 2.6.6
    if ::Mail::CheckDeliveryParams.respond_to?(:check)
      private def open_envelope(mail)
        ::Mail::CheckDeliveryParams.check(mail)
      end
    else
      include ::Mail::CheckDeliveryParams
      private def open_envelope(mail)
        check_delivery_params(mail)
      end
    end

    def initialize(settings = {})
      @settings = settings.dup
    end

    def deliver!(mail)
      smtp_envelope_from, smtp_envelope_to, message = open_envelope(mail)
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

