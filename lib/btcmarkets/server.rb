# frozen_string_literal: true

module BTCMarkets
  class Server
    class << self
      def time
        Client.public_send(path: '/v3/time')
      end
    end
  end
end
