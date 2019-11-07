# frozen_string_literal: true

module BTCMarkets
  class Client
    include HTTParty

    base_uri 'https://api.btcmarkets.net'

    class << self
      def public_send(path: '/', params: {})
        response = get(path, query: params)
        process(response)
      end

      def private_send(method, path, params: {})
        case method
        when :get
          response = send(method, path, headers: build_headers(method.to_s, path), query: params)
        else
          response = send(method, path, headers: build_headers(method.to_s, path, params), body: params)
        end
        process(response)

      end

      private

      def build_headers(method, path, params={})
        timestamp = Helpers::Time.timestamp.to_s

        {
          "Accept": 'application/json',
          "Accept-Charset": 'UTF-8',
          "Content-Type": 'application/json',
          "BM-AUTH-APIKEY": Authentication.api_public_key,
          "BM-AUTH-TIMESTAMP": timestamp,
          "BM-AUTH-SIGNATURE": Authentication.signature(payload(method, path, timestamp, params))
        }
      end

      def payload(method, path, timestamp, params)
        method = method.upcase
        unless params.empty?
          return "#{method}#{path}#{timestamp}#{params.to_json}"
        end

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
