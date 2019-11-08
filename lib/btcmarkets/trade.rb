# frozen_string_literal: true

module BTCMarkets
  class Trade
    class << self
      def trades(params={})
        Client.private_send(:get, '/v3/trades', params: params)
      end

      def trade(id)
        Client.private_send(:get, "/v3/trades/#{id}")
      end
    end
  end
end
