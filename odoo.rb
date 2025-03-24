require "active_support/all"
require "resty"

require "odoo/version"

module Odoo
  include Resty

  JSONRPC_VERSION = "2.0".freeze

  class << self
    attr_accessor :api_key

    def default_service_path(_klass)
      "/titan".freeze
    end

    def default_api_version(_klass)
      "v2".freeze
    end

    def default_resource_slug(klass)
      super.camelize(:lower).underscore
    end

    def default_object_key(_klass)
      :result
    end

    def default_list_key(_klass)
      :result
    end
  end
end

# Resty Override Classes
require "odoo/api_resource"
require "odoo/client"
require "odoo/response"
require "odoo/conflict_error"

# API Resources
require "odoo/delivery_order"
require "odoo/product"
require "odoo/warehouse"
