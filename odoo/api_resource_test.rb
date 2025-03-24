require "test_helper"

module Odoo
  class MockResource < ApiResource
    property :name
  end

  class ApiResourceTest < MiniTest::Spec
    describe "#save" do
      it "should raise a NotImplementedError" do
        assert_raises(NotImplementedError) { MockResource.new.save }
      end
    end
  end
end
