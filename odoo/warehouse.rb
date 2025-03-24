module Odoo
  class Warehouse < Odoo::ApiResource
    include List

    property :id, from: :code
    property :name
    property :code

    def inventory
      @inventory ||= begin
        resp = request(self.class.list_method, "#{self.class.resource_path(id)}/inventory")
        construct_inventory_from(resp.data)
      end
    end

    private

    def construct_inventory_from(payload)
      values = payload.deep_symbolize_keys
      Inventory.construct_from(values)
    end

    class Inventory < ListObject
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
        property :unreserved
        property :breakdown, transform_with: ->(value) { Breakdown.new(value) }
        property :delegated_sku, from: :delegate

        alias sku id

        def available
          breakdown&.available || 0
        end

        def delegated?
          delegated_sku.present?
        end

        class Breakdown < Object
          property :available
          property :lots, transform_with: ->(values) { values.map(&Lot) }
        end

        class Lot < Object
          def self.to_proc
            ->(attrs) { new(attrs) }
          end

          property :category
          property :name
          property :total
          property :expires_on, transform_with: ->(value) { Date.parse(value) }
          property :remove_on,  transform_with: ->(value) { Date.parse(value) }
        end
      end
    end
  end
end
