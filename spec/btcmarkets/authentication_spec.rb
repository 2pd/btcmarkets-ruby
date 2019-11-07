# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Authentication do
  describe '#api_public_key' do
    before do
      ENV['BTCMARKETS_PUBLIC_KEY'] = 'aaaa'
    end

    it { expect(described_class.api_public_key).to eq 'aaaa' }
  end

  describe '#api_private_key' do
    before do
      ENV['BTCMARKETS_PRIVATE_KEY'] = 'bbb'
    end

    it { expect(described_class.api_private_key).to eq 'bbb' }
  end
end
