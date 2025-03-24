require "test_helper"

module Odoo
  class WarehouseTest < Minitest::Spec
    subject { Warehouse }

    describe "properties" do
      it { assert_resource_property(:id, from: :code) }
      it { assert_resource_property(:name) }
      it { assert_resource_property(:code) }
    end

    describe "#inventory" do
      subject { Warehouse.new("TJ").inventory }

      before do
        stub_request(:get, api_url("/warehouses/TJ/inventory"))
          .to_return(body: load_fixture("warehouses/tj.inventory.json"))
      end

      it "should return an Inventory object" do
        inventory = subject

        assert_requested(:get, api_url("/warehouses/TJ/inventory"))
        assert_instance_of(Warehouse::Inventory, inventory)
      end
    end

    describe ".retrieve" do
      subject { Warehouse.retrieve("TJ") }

      before do
        stub_request(:get, api_url("/warehouses/TJ"))
          .to_return(body: load_fixture("warehouses/tj.json"))
      end

      it "should be retrievable" do
        warehouse = Warehouse.retrieve("TJ")

        assert_requested :get, api_url("/warehouses/TJ")
        assert_instance_of Warehouse, warehouse
      end
    end

    describe ".list" do
      subject { Warehouse.list }

      before do
        stub_request(:get, api_url("/warehouses"))
          .to_return(body: load_fixture("warehouses/list.json"))
      end

      it "should be listable" do
        assert_instance_of ListObject, subject
        assert_requested :get, api_url("/warehouses")
      end

      it "should have hydrated Warehouses" do
        warehouse = subject.first

        assert_instance_of Warehouse, warehouse
      end
    end
  end
end
