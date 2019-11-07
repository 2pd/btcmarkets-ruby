# frozen_string_literal: true

module BTCMarkets
  class Account
    class << self
      def balance
        Client.private_send(:get, '/v3/accounts/me/balances')
      end
    end
  end
end
