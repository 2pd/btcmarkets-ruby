# frozen_string_literal: true

module BTCMarkets
  class Client
    include HTTParty
    debug_output $stdout

    base_uri 'https://api.btcmarkets.net'

    class << self
      def public_send(path: '/', params: {})
        response = get(path, query: params)
        process(response)
      end

      def private_send(method, path, params: {})
        response = get(path, headers: build_headers(method.to_s, path, params), body: params )
        process(response)
        # send(method, path: path, headers: build_headers(method.to_s, path, params), body: params )
      end

      private

      def build_headers(method, path, params)
        timestamp = Helpers::Time.timestamp.to_s
        puts payload(method, path, timestamp, params)
        {
          "Accept": 'application/json',
          "Accept-Charset": "UTF-8",
          "Content-Type": 'application/json',
          "BM-AUTH-APIKEY": Authentication.api_public_key,
          "BM-AUTH-TIMESTAMP": timestamp,
          "BM-AUTH-SIGNATURE": Authentication.signature(payload(method, path, timestamp, params))
        }
      end

      def payload(method, path, timestamp, params)
        method = method.upcase
        return "#{method}#{path}#{timestamp}#{params.to_json}" unless params.empty?

        "#{method}#{path}#{timestamp}"
      end

      def process(response)
        data = JSON.parse(response.body, symbolize_names: true)
        raise Error.new(response.code, data) if Error.error_response?(response)

        data
      end
    end
  end
end
