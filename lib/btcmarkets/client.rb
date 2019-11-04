# frozen_string_literal: true

module BTCMarkets
  class Client
    include HTTParty

    base_uri 'https://api.btcmarkets.net/v3/'

    class << self
      def public_send(path: '/', params: {})
        response = get(path, query: params)
        process(response)
      end

      private

      def process(response)
        data = JSON.parse(response.body, symbolize_names: true)
        raise Error.new(response.code, data) if Error.error_response?(response)

        data
      end
    end
  end
end
