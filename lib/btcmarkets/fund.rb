# frozen_string_literal: true

module BTCMarkets
  class Fund
    class << self
      def deposit_address(asset)
        Client.private_send(:get, '/v3/addresses', params: { 'assetName': asset})
      end
    end
  end
end
