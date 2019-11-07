# frozen_string_literal: true

require 'base64'

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
        Base64.strict_encode64(OpenSSL::HMAC.digest('sha512', base64_encrypted_key, payload))
      end

      def base64_encrypted_key
        puts "test"
        puts api_private_key
        Base64.decode64(api_private_key)
      end
    end
  end
end
