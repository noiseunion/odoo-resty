module Odoo
  class Product < ApiResource
    include List

    property :id, from: :sku
    property :name
    property :width
    property :height
    property :depth
    property :weight
    property :msrp_cents, from: :msrp_in_cents
    property :cogs_cents, from: :cogs_in_cents
    property :business_unit
    property :category
    property :hs_code

    alias sku id

    def bom
      @bom ||= begin
        resp = request(self.class.list_method, "#{resource_path}/bom")
        construct_bom_lines_from(resp.data)
      end
    end

    private

    def construct_bom_lines_from(payload)
      BOM.construct_from(payload.deep_symbolize_keys)
    end

    class BOM < ListObject
      def self.construct_from(values)
        super(values, Line)
      end

      def find_by_sku(sku)
        find { |line| line.id.casecmp?(sku) }
      end

      class Line < Object
        def self.list_key
          api_module.default_list_key(self)
        end

        property :id, from: :sku
        property :name
        property :quantity
        property :parent_sku

        alias sku id
      end
    end
  end
end
