require "mail/version"

module Maillog
  class DeliveryMethod
    attr_accessor :settings

    mail_version = ::Gem::Version.new(::Mail::VERSION.version)
    case
    when mail_version >= ::Gem::Version.new("2.8.0")
      private def open_envelope(mail)
        envelope = ::Mail::SmtpEnvelope.new(mail)
        [envelope.from, envelope.to, envelope.message]
      end
    when mail_version >= ::Gem::Version.new("2.5.5"),
         mail_version >= ::Gem::Version.new("2.6.6")
      require "mail/check_delivery_params"
      private def open_envelope(mail)
        ::Mail::CheckDeliveryParams.check(mail)
      end
    else
      require "mail/check_delivery_params"
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

      if callbacks = mail.instance_variable_get(:@maillog_callbacks)
        callbacks.each do |callback|
          callback.call(log)
        end
      end

      log.deliver
    end

    private
    def log_mail(message, bcc)
      Maillog.model.create!(message: message, bcc: bcc, state: "delivered")
    end
  end
end

