require "test_helper"

module Odoo
  class ConflictErrorTest < Minitest::Spec
    STATUS = 409

    describe "#already_submitted?" do
      it "should return false when the error message is not ALREADY_SUBMITTED_MSG" do
        response_body = { error: { data: { message: "foo" } } }.to_json
        wrapped_error = Faraday::ConflictError.new("fake error", { status: STATUS, body: response_body })
        error = ConflictError.new(wrapped_error)

        refute_predicate error, :already_submitted?
      end

      it "should return true when the error message is ALREADY_SUBMITTED_MSG" do
        response_body = { error: { data: { message: ConflictError::ALREADY_SUBMITTED_MSG } } }.to_json
        wrapped_error = Faraday::ConflictError.new("fake error", { status: STATUS, body: response_body })
        error = ConflictError.new(wrapped_error)

        assert_predicate error, :already_submitted?
      end
    end

    describe "#data" do
      it "should return the data from the wrapped error" do
        response_body = { foo: "bar" }.to_json
        wrapped_error = Faraday::ConflictError.new("fake error", { status: STATUS, body: response_body })
        error = ConflictError.new(wrapped_error)

        assert_equal({ foo: "bar" }, error.data)
      end
    end
  end
end
