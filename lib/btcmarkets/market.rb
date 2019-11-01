# frozen_string_literal: true

module BTCMarkets
  class Market
    class << self
      def markets
        Client.public_send(path: '/markets')
      end

      def ticker(pair)
        Client.public_send(path: "/markets/#{pair}/ticker")
      end
    end
  end
end
