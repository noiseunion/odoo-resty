module Odoo
  class Client < Resty::Client
    # TODO: Remove once all legacy items have been refactored to the V2 API
    def post(path, **params)
      execute_request(:post, path, params:).to_v1
    rescue Faraday::ServerError => e
      Response.from_faraday_response(Hashie::Mash.new(e.response)).to_v1
    end

    def put(path, **params)
      execute_request(:put, path, params:).to_v1
    rescue Faraday::ServerError => e
      Response.from_faraday_response(Hashie::Mash.new(e.response)).to_v1
    end

    protected

    def request_headers
      super.merge("api-key" => Odoo.api_key)
    end

    private

    # An Odoo JSONRPC payload is required so we manage building that out here
    def process_params(method, params)
      body = { jsonrpc: Odoo::JSONRPC_VERSION, id: SecureRandom.uuid }
      query_params = nil
      case method.to_s.downcase.to_sym
      when :get, :head, :delete
        query_params = params
      else
        body = body.merge(params:)
      end
      [body.to_json, query_params]
    end
  end
end
