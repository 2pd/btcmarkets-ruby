
# frozen_string_literal: true

module BTCMarkets
  class Server
    class << self
      def time
        Client.public_send(path: '/time')
      end
    end
  end
end
