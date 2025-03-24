require "test_helper"

module Odoo
  class Warehouse
    class Inventory
      class LineTest < Minitest::Spec
        subject { Line }

        describe "properties" do
          it { assert_resource_property(:id, from: :sku) }
          it { assert_resource_property(:unreserved) }
          it do
            assert_resource_property(:breakdown, transform_to: Line::Breakdown) do
              { available: 100, lots: [] }
            end
          end

          it { assert_resource_property(:delegated_sku, from: :delegate) }
        end

        it "should respond to #sku" do
          line = Line.new({ sku: "KTCR-0037-WHA" })

          assert_equal "KTCR-0037-WHA", line.sku
          assert_equal "KTCR-0037-WHA", line.id
        end

        describe "#available" do
          it "should default to 0" do
            line = Line.new({})

            assert_equal 0, line.available
          end

          it "should return the breakdown value when present" do
            line = Line.new({ breakdown: { available: 123 } })

            assert_equal 123, line.available
          end
        end

        describe "#delegated?" do
          it "should know when it is delegated" do
            line = Line.new({ delegate: "foobar" })

            assert_predicate line, :delegated?
          end

          it "should know when it is not delegated" do
            line = Line.new

            refute_predicate line, :delegated?
          end
        end
      end

      class BreakdownTest < Minitest::Spec
        subject { Line::Breakdown }

        describe "properties" do
          it { assert_resource_property :available }
          it do
            assert_resource_property :lots, transform_to: Array do
              {}
            end
          end
        end
      end

      class LotTest < Minitest::Spec
        subject { Line::Lot }

        describe "properties" do
          it { assert_resource_property :category }
          it { assert_resource_property :name }
          it { assert_resource_property :total }
          it do
            assert_resource_property(:expires_on, transform_to: Date) { "2024-10-02T15:21:27Z" }
          end
          it do
            assert_resource_property(:remove_on, transform_to: Date) { "2024-10-02T15:21:27Z" }
          end
        end
      end
    end
  end
end
