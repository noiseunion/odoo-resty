module Odoo
  class ConflictError
    ALREADY_SUBMITTED_MSG = "Shipment UUID is globally unique".freeze

    def already_submitted?
      data.dig(:error, :data, :message).to_s.casecmp?(ALREADY_SUBMITTED_MSG)
    end

    def data
      JSON.parse(wrapped_exception.response_body, symbolize_names: true)
    end
  end
end
