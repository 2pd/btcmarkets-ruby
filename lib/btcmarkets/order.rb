# frozen_string_literal: true

module BTCMarkets
  class Order
    class << self
      def create(params={})
        Client.private_send(:post, '/v3/orders', params: params)
      end

      def cancel(id)
        Client.private_send(:delete, "/v3/orders/#{id}")
      end
    end
  end
end
