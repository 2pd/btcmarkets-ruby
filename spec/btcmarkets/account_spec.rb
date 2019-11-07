# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Account do
  before do
    ENV['BTCMARKETS_PUBLIC_KEY'] = public_key
    ENV['BTCMARKETS_PRIVATE_KEY'] = private_key
  end

  shared_examples 'a valid http request' do
    it 'should send api request' do
      subject
      expect(request_stub).to have_been_requested
    end
  end

  describe '#balance' do
    let(:public_key) { 'xxx' }
    let(:private_key) { 'xxx' }
    let(:path) {'/v3/accounts/me/balances' }
    let(:timestamp) { Helpers::Time.timestamp }
    let(:payload) { "GET#{path}#{timestamp}"}
    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}#{path}")
        .with(headers: {
          "Accept": 'application/json',
          "Accept-Charset": 'UTF-8',
          "Content-Type": 'application/json',
          "BM-AUTH-APIKEY": public_key,
          "BM-AUTH-TIMESTAMP": timestamp,
          "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
          })
        .to_return_200
    end
    subject { described_class.balance }
    include_examples 'a valid http request'
  end
end
