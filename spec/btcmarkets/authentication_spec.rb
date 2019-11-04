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

  describe '#signature' do
    let(:key) { 'aaaa' }
    let(:payload) { 'test' }

    before do
      ENV['BTCMARKETS_PRIVATE_KEY'] = key
    end

    it 'should encript' do
      digest = OpenSSL::Digest::SHA512.new
      signature = OpenSSL::HMAC.hexdigest(digest, key, payload)
      expect(described_class.signature(payload)).to eq signature
    end
  end
end
