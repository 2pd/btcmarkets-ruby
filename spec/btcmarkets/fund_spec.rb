# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Fund do
  let(:public_key) { 'xxx' }
  let(:private_key) { 'xxx' }
  let(:timestamp_second) { '1573122562' }
  let(:timestamp) { '1573122562000' }

  before do
    allow(Time).to receive(:now).and_return(timestamp_second)
    ENV['BTCMARKETS_PUBLIC_KEY'] = public_key
    ENV['BTCMARKETS_PRIVATE_KEY'] = private_key
  end

  shared_examples 'a valid http request' do
    it 'should send api request' do
      subject
      expect(request_stub).to have_been_requested
    end
  end

  describe '#deposit_address' do
    let(:path) { '/v3/addresses' }
    let(:payload) { "GET#{path}#{timestamp}" }
    let(:asset) { 'BTC' }
    let(:query_params) do
      {
        "assetName": asset
      }
    end
    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}#{path}")
        .with(
          query: query_params,
          headers: {
            "Accept": 'application/json',
            "Accept-Charset": 'UTF-8',
            "Content-Type": 'application/json',
            "BM-AUTH-APIKEY": public_key,
            "BM-AUTH-TIMESTAMP": timestamp,
            "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
          }
        )
        .to_return_200
    end
    subject { described_class.deposit_address(asset) }
    include_examples 'a valid http request'
  end
end
