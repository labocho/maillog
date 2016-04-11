require "maillog/actual_delivery"
require "maillog/delivery_method"
require "maillog/mailer"
require "maillog/mail"
require "maillog/version"

module Maillog
  class << self
    attr_accessor :model_class_name, :mailer_class_name

    def model
      return @model if @model
      m = model_class_name.constantize
      if cache_classes?
        @model = m
      end
      m
    end

    def mailer
      return @mailer if @mailer
      m = mailer_class_name.constantize
      if cache_classes?
        @mailer = m
      end
      m
    end

    def cache_classes?
      return true unless defined?(Rails) && Rails.respond_to?(:application)
      Rails.application.config.cache_classes
    end
  end

  self.model_class_name = "Maillog::Mail"
  self.mailer_class_name = "Maillog::Mailer"
end

ActionMailer::Base.add_delivery_method :maillog, Maillog::DeliveryMethod
