# frozen_string_literal: true

module BTCMarkets
  class Client
    include HTTParty

    base_uri 'https://api.btcmarkets.net/v3/'

    class << self
      def public_send(method: :get, path: '/', params: {})
        response = get(path)
        process(response)
      end

      private

      def process(response)
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
