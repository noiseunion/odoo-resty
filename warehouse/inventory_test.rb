require "test_helper"

module Odoo
  class Warehouse
    class InventoryTest < Minitest::Spec
      subject { Inventory }

      before do
        payload = { result: [{ sku: "KTCR-0037-WHA", unreserved: 0 }] }
        @inventory = subject.construct_from(payload)
      end

      describe ".construct_from" do
        it "should construct Lines from an array" do
          assert_instance_of Inventory::Line, @inventory.first
        end
      end

      describe "#find_by_sku" do
        it "should return nil when the sku is not found" do
          assert_nil @inventory.find_by_sku("XYZ")
        end

        it "should return the line when found" do
          assert_instance_of Inventory::Line, @inventory.find_by_sku("KTCR-0037-WHA")
        end
      end
    end
  end
end
