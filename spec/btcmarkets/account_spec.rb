# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Account do
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

  describe '#balance' do
    let(:path) { '/v3/accounts/me/balances' }
    let(:payload) { "GET#{path}#{timestamp}" }
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

  describe '#transactions' do
    context 'default params' do
      let(:path) { '/v3/accounts/me/transactions' }
      let(:timestamp) { Helpers::Time.timestamp }
      let(:payload) { "GET#{path}#{timestamp}" }
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
      subject { described_class.transactions }
      include_examples 'a valid http request'
    end

    context 'with params' do
      let(:path) { '/v3/accounts/me/transactions' }
      let(:timestamp) { Helpers::Time.timestamp }
      let(:payload) { "GET#{path}#{timestamp}" }
      let(:query_params) do
        {
          "assetName": 'BTC',
          "before": '78234976',
          "after": '78234876',
          "limit": 10
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
      subject { described_class.transactions(query_params) }
      include_examples 'a valid http request'
    end
  end
end
