require "test_helper"

module Odoo
  class DeliveryOrderTest < Minitest::Spec
    subject { DeliveryOrder }

    describe "properties" do
      it { assert_resource_property(:id, from: :titan_uuid) }
      it { assert_resource_property(:name) }
      it { assert_resource_property(:state) }
      it { assert_resource_property(:warehouse) }
      it { assert_resource_property(:origin) }
      it { assert_resource_property(:order_token, from: :order_id) }
      it { assert_resource_property(:expedited) }
      it { assert_resource_property(:item_count) }
      it { assert_resource_property(:created_at, transform_to: DateTime) }
      it { assert_resource_property(:done_at) }
      it { assert_resource_property(:scheduled_on) }
      it { assert_resource_property(:metadata) }
      it { assert_resource_property(:confirmed) }
    end

    describe ".list" do
      before do
        stub_request(:get, api_url("/delivery_orders"))
          .to_return(body: load_fixture("delivery_orders/list.json"))
      end

      it "should be listable" do
        delivery_orders = DeliveryOrder.list

        assert_requested :get, api_url("/delivery_orders")
        assert_instance_of ListObject, delivery_orders
      end
    end

    describe ".retrieve" do
      before do
        @uuid = SecureRandom.uuid
        stub_request(:get, api_url("/delivery_orders/#{@uuid}"))
          .to_return(body: load_fixture("delivery_orders/retrieve.json"))
      end

      it "should be retrievable" do
        delivery_order = DeliveryOrder.retrieve(@uuid)

        assert_requested :get, api_url("/delivery_orders/#{@uuid}")
        assert_instance_of DeliveryOrder, delivery_order
      end
    end

    describe "#status" do
      before do
        @uuid = SecureRandom.uuid
        stub_request(:get, api_url("/delivery_orders/#{@uuid}/status"))
          .to_return(body: load_fixture("delivery_orders/status.json"))
      end

      it "should return the current status of the delivery order" do
        status = DeliveryOrder.new(@uuid, values: { titan_uuid: @uuid }).status

        assert_requested(:get, api_url("/delivery_orders/#{@uuid}/status"))
        assert_equal "done", status.state
        assert_equal "Done", status.label
      end
    end

    describe "#cancel!" do
      before do
        @uuid = SecureRandom.uuid
        stub_request(:put, api_url("/delivery_orders/#{@uuid}/cancel"))
          .to_return(body: load_fixture("delivery_orders/cancelled.json"))
        stub_request(:get, api_url("/delivery_orders/#{@uuid}"))
          .to_return(body: load_fixture("delivery_orders/cancelled.json"))
      end

      it "should cancel the delivery order" do
        DeliveryOrder.new(@uuid, values: { titan_uuid: @uuid }).cancel!

        assert_requested(:put, api_url("/delivery_orders/#{@uuid}/cancel"))
        assert_requested(:get, api_url("/delivery_orders/#{@uuid}"))
      end
    end

    describe "#commercial_invoice" do
      before do
        @uuid = SecureRandom.uuid
        stub_request(:get, api_url("/delivery_orders/#{@uuid}/commercial_invoice"))
          .to_return(body: load_fixture("delivery_orders/commercial_invoice.json"))
      end

      it "should return the commercial invoice lines" do
        commercial_invoice = DeliveryOrder.new(@uuid, values: { titan_uuid: @uuid }).commercial_invoice

        assert_requested(:get, api_url("/delivery_orders/#{@uuid}/commercial_invoice"))
        assert_instance_of(DeliveryOrder::CommercialInvoice, commercial_invoice)
        assert_instance_of(DeliveryOrder::CommercialInvoice::Line, commercial_invoice.first)
      end
    end

    class CommercialInvoiceLineTest < Minitest::Spec
      subject { DeliveryOrder::CommercialInvoice::Line }

      describe "properties" do
        it { assert_resource_property(:name) }
        it { assert_resource_property(:sku, from: :code) }
        it { assert_resource_property(:quantity) }
        it { assert_resource_property(:unit_weight) }
        it { assert_resource_property(:currency) }
        it { assert_resource_property(:unit_value_cents, from: :unit_value_in_cents) }
      end

      it "should return the default list key" do
        assert_equal Odoo.default_list_key(nil), subject.list_key
      end
    end
  end
end
