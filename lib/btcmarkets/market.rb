# frozen_string_literal: true

module BTCMarkets
  class Market
    class << self
      def markets
        Client.public_send(path: '/markets')
      end

      def ticker(market_id)
        Client.public_send(path: "/markets/#{market_id}/ticker")
      end

      def tickers(market_ids = [])
        params = { 'marketId': market_ids } unless market_ids.empty?
        Client.public_send(path: '/markets/tickers', params: params)
      end

      def trades(market_id, params = {})
        Client.public_send(path: "/markets/#{market_id}/trades", params: params)
      end

      def orderbook(market_id, params = {})
        Client.public_send(path: "/markets/#{market_id}/orderbook", params: params)
      end
    end
  end
end
