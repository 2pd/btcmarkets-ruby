# frozen_string_literal: true

module BTCMarkets
  class Account
    class << self
      def balance
        Client.private_send(:get, '/v3/accounts/me/balances')
      end

      def transactions(params={})
        Client.private_send(:get, '/v3/accounts/me/transactions', params: params)
      end
    end
  end
end
