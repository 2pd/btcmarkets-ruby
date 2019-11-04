# frozen_string_literal: true

module BTCMarkets
  class Authentication
    class << self
      def api_public_key
        ENV['BTCMARKETS_PUBLIC_KEY']
      end

      def api_private_key
        ENV['BTCMARKETS_PRIVATE_KEY']
      end

      def signature(payload)
        digest = OpenSSL::Digest::SHA512.new
        OpenSSL::HMAC.hexdigest(digest, api_private_key, payload)
      end
    end
  end
end
