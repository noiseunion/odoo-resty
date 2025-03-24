require "test_helper"

module Odoo
  class ProductTest < Minitest::Spec
    subject { Product }

    describe "properties" do
      it { assert_resource_property(:id, from: :sku) }
      it { assert_resource_property(:name) }
      it { assert_resource_property(:width) }
      it { assert_resource_property(:height) }
      it { assert_resource_property(:depth) }
      it { assert_resource_property(:weight) }
      it { assert_resource_property(:msrp_cents, from: :msrp_in_cents) }
      it { assert_resource_property(:cogs_cents, from: :cogs_in_cents) }
      it { assert_resource_property(:business_unit) }
    end

    it "should respond to #sku" do
      product = Product.new({ sku: "FAKE-SKU-0001" })

      assert_equal product.sku, product.id
    end

    describe "#bom" do
      before do
        @sku = "KTCR-0037-WHA"
        stub_request(:get, api_url("/products/#{@sku}/bom"))
          .to_return(body: load_fixture("products/bom.json"))
      end

      it "should return a BOM object" do
        bom = Product.new(@sku).bom

        assert_requested :get, api_url("/products/#{@sku}/bom")
        assert_instance_of Product::BOM, bom
        assert_kind_of ListObject, bom
      end

      describe "#find_by_sku" do
        before do
          @bom = Product.new(@sku).bom
        end

        it "should return nil when the sku is not found" do
          assert_nil @bom.find_by_sku("XYZ")
        end

        it "should return the line when found" do
          assert_instance_of Product::BOM::Line, @bom.find_by_sku("MECR-0003-GN7")
        end
      end
    end

    describe ".list" do
      before do
        stub_request(:get, api_url("/products"))
          .to_return(body: load_fixture("products/list.json"))
      end

      it "should be listable" do
        products = Product.list

        assert_requested :get, api_url("/products")
        assert_instance_of ListObject, products
        assert_instance_of Product, products.first
      end
    end

    describe ".retrieve" do
      before do
        @sku = "KTCR-0037-WHA"
        stub_request(:get, api_url("/products/#{@sku}"))
          .to_return(body: load_fixture("products/retrieve.json"))
      end

      it "should be retrievable" do
        product = Product.retrieve @sku

        assert_requested :get, api_url("/products/#{@sku}")
        assert_instance_of Product, product
      end
    end
  end

  class Product
    class BOM
      class LineTest < Minitest::Spec
        subject { Product::BOM::Line }

        describe "properties" do
          it { assert_resource_property(:id, from: :sku) }
          it { assert_resource_property(:name) }
          it { assert_resource_property(:quantity) }
          it { assert_resource_property(:parent_sku) }
        end

        it "should respond to #sku" do
          line = Product::BOM::Line.new({ sku: "FAKE-SKU-0001" })

          assert_equal line.sku, line.id
        end
      end
    end
  end
end
