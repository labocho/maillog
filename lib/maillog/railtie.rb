module Maillog
  class Railtie < Rails::Railtie
    ActionMailer::Base.add_delivery_method :maillog, Maillog::DeliveryMethod
  end
end
