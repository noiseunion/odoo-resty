require "test_helper"

class OdooTest < Minitest::Spec
  subject { Odoo }

  it "should include Resty" do
    assert_includes subject, Resty
  end

  it "should have a version number" do
    assert_match(/.+\..+\..+/, subject::VERSION)
  end

  # rubocop:disable Minitest/MultipleAssertions
  it "should define API default behaviors" do
    assert_equal "/titan",        subject.default_service_path(subject::ApiResource)
    assert_equal "v2",            subject.default_api_version(subject::ApiResource)
    assert_equal "api_resources", subject.default_resource_slug(subject::ApiResource)
    assert_equal :result,         subject.default_object_key(subject::ApiResource)
    assert_equal :result,         subject.default_list_key(subject::ApiResource)
  end

  it "should support all built-in config properties" do
    assert_config_property(:logger)
    assert_config_property(:api_base)
    assert_config_property(:open_timeout, 15)
    assert_config_property(:read_timeout, 30)
  end
  # rubocop:enable Minitest/MultipleAssertions

  it "should support custom config properties" do
    assert_config_property(:api_key)
  end

  it "should have a valid api_url test helper" do
    assert_equal "http://odoo.example.com/titan/v2/path", api_url("path")
  end

  def assert_config_property(property, value = "value", subject: nil)
    subject ||= (defined?(@subject) && @subject) || subject()
    old = subject.send(property)
    subject.send(:"#{property}=", value)

    assert_equal value, subject.send(property), "config property #{property} value did not match assignment value"
  ensure
    subject.send(:"#{property}=", old)
  end
end
