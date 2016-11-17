require "active_support/rescuable" # actionmailer 5.0.0.1 failed to load ActiveSupport::Rescuable
require "action_mailer"

module Maillog
  class Mailer < ActionMailer::Base
  end
end
