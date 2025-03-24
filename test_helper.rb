if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/vendor/"
    add_filter "/test/"
  end
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "odoo"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/spec"
require "webmock/minitest"

# override with MINITEST_REPORTER env var
Minitest::Reporters.use!

WebMock.disable_net_connect!(allow_localhost: true)

Odoo.configure do |config|
  config.api_base = "http://odoo.example.com/"
  config.api_key = "ABCDEFG"
end

module MiniTest
  class Spec
    make_my_diffs_pretty!

    def api_url(path)
      Odoo::Client.api_url(Odoo::ApiResource.api_path(path))
    end
  end
end

def load_fixture(file_name)
  File.read(File.expand_path("fixtures/#{file_name}", __dir__))
end

# rubocop:disable Metrics/AbcSize
def assert_resource_property(property, from: nil, transform_to: nil, &block)
  subject ||= (defined?(@subject) && @subject) || subject()

  assert subject.property?(property.to_sym), "API resource property #{property} was not found"
  return if from.blank?

  assert_equal(
    property.to_sym,
    subject.translations[from.to_sym],
    "property #{property} is not configured to pull from #{from}",
  )
  return unless transform_to.present?

  assert subject.transformation_exists?(property.to_sym), "property #{property} has no defined transform"
  return unless block

  assert_instance_of(
    transform_to,
    subject.transformed_property(property.to_sym, yield),
    "property #{property} was not transformed to the expected type",
  )
end
# rubocop:enable Metrics/AbcSize
