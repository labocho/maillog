require 'test_helper'

class MaillogTest < Test::Unit::TestCase
  class TestMailer < ActionMailer::Base
    self.delivery_method = :maillog

    def test
      mail(from: "test@example.com", to: "test@example.com", subject: "test", body: "Hello")
    end
  end

  class << self
    def startup
      ActionMailer::Base.delivery_method = :test

      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: ":memory:",
      )

      Dir.mktmpdir do |migration_dir|
        FileUtils.cp "#{__dir__}/../lib/generators/templates/create_maillogs.rb", "#{migration_dir}/001_create_maillogs.rb"
        ActiveRecord::Migrator.migrate(migration_dir, nil)
      end
    end
  end

  test "that it has a version number" do
    assert { ::Maillog::VERSION }
  end

  test "deliver mail via ActionMailer::Base.delivery_method" do
    assert_change(->{ ActionMailer::Base.deliveries.count }, by: 1) {
      TestMailer.test.deliver_now
    }
  end

  test "store mail on database" do
    assert_change(-> { Maillog::Mail.count }, by: 1) {
      TestMailer.test.deliver_now
    }
    assert { Maillog::Mail.last.state == "delivered" }
  end

  test "dont store mail for mail delivered by another delivery_method" do
    assert_change(-> { ActionMailer::Base.deliveries.count }, by: 1) {
      assert_not_change(-> { Maillog::Mail.count }) {
        another_mailer.test.deliver_now
      }
    }
  end

  test "if raise exception on delivering, store exception" do
    stub.proxy(::Mail::TestMailer).new do |obj|
      stub(obj).deliver!{ raise Net::OpenTimeout }
    end
    assert_not_change(-> { ActionMailer::Base.deliveries.count }) {
      assert_change(-> { Maillog::Mail.count }, by: 1) {
        TestMailer.test.deliver_now
      }
    }
    failed = Maillog::Mail.last
    assert { failed.state == "failed" }
    assert { failed.exception_class_name == "Net::OpenTimeout" }
  end

  private
  def another_mailer
    @another_mailer ||= Class.new(ActionMailer::Base) {
      def test
        mail(from: "test@example.com", to: "test@example.com", subject: "test", body: "Hello")
      end
    }
  end

  def assert_change(val_proc, by: nil, &block)
    before = val_proc.call
    yield
    after = val_proc.call
    if by
      assert { after - by == before }
    else
      assert { before != after }
    end
  end

  def assert_not_change(val_proc, &block)
    before = val_proc.call
    yield
    after = val_proc.call
    assert { before == after }
  end
end
