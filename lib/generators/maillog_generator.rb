require "rails/generators/active_record/migration"

class MaillogGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path("../templates", __FILE__)

  def migration
    migration_template "create_maillogs.rb", "db/migrate/create_maillogs.rb"
  end
end
