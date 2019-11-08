# frozen_string_literal: true

module BTCMarkets
  class Order
    class << self
      def create(params={})
        Client.private_send(:post, '/v3/orders', params: params)
      end
    end
  end
end
