# frozen_string_literal: true

module BTCMarkets
  class Account
    class << self
      def balance
        Client.private_send(:get, '/v3/accounts/me/balances')
      end

      def transactions
        Client.private_send(:get, '/v3/accounts/me/transactions')
      end
    end
  end
end
