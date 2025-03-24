module Odoo
  class DeliveryOrder < ApiResource
    include List
    include Save

    PARSE_ISO8601 = lambda do |value|
      DateTime.parse(value)
    rescue TypeError
      value
    end.freeze

    property :store_front
    property :id, from: :titan_uuid
    property :uuid
    property :name
    property :state
    property :warehouse
    property :origin
    property :order_token, from: :order_id
    property :expedited
    property :item_count
    property :created_at, transform_with: PARSE_ISO8601
    property :done_at, transform_with: PARSE_ISO8601
    property :scheduled_on, transform_with: PARSE_ISO8601
    property :metadata, default: {}
    property :confirmed, default: false
    property :shipping
    property :metadata
    property :line_items
    property :order

    def commercial_invoice
      @commercial_invoice ||= begin
        resp = request(self.class.list_method, "#{resource_path}/commercial_invoice")
        construct_commercial_invoice_lines_from(resp.data)
      end
    end

    def status
      @status ||= begin
        payload = request(:get, "#{resource_path}/status")
        Status.new(payload.data[self.class.object_key])
      end
    end

    def cancel!
      request(:put, "#{resource_path}/cancel")
      refresh
    end

    private

    def construct_commercial_invoice_lines_from(payload)
      CommercialInvoice.construct_from(payload.deep_symbolize_keys)
    end

    class Shipping < Object
      property :expedited
      property :carrier
      property :method
    end

    class CommercialInvoice < ListObject
      def self.construct_from(values)
        super(values, Line)
      end

      class Line < Object
        def self.list_key
          api_module.default_list_key(self)
        end

        property :name
        property :sku, from: :code
        property :quantity
        property :unit_weight
        property :currency
        property :unit_value_cents, from: :unit_value_in_cents
      end
    end

    class Status < Object
      property :state
      property :label
      property :help
    end
  end
end
