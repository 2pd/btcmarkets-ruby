# frozen_string_literal: true

module BTCMarkets
  class Error < StandardError
    attr_reader :status, :message, :data

    class << self
      def error_response?(response)
        response.code >= 400
      end
    end

    def initialize(status, data = {})
      @status = status
      @message = data[:message]
      @data = data
    end
  end
end
