# frozen_string_literal: true

module Helpers
  class Time
    def self.timestamp
      (::Time.now.to_f * 1000).to_i
    end
  end
end
