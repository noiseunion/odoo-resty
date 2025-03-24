module Odoo
  class Response
    alias status http_status

    # V1 Response Concepts
    attr_reader :raw, :id

    def to_v1
      @raw    = data
      mash    = Hashie::Mash.new(@raw)
      @data   = mash.fetch(:result, Hashie::Mash.new)
      @error  = mash.fetch(:error, Hashie::Mash.new)
      @id     = @raw[:id]
      self
    end

    def error
      @error ||= Hashie::Mash.new(data[:error] || {})
    end
  end
end
