# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Order do
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

  describe '#create' do

    context 'buy a limit order' do
      let(:path) { '/v3/orders' }
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Bid'
        }
      end
      let(:payload) { "POST#{path}#{timestamp}#{body_params.to_json}" }
      let(:request_body) { body_params.map { |key, value| "#{key}=#{value}" }.join('&') }

      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: request_body,
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
      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a limit order' do
      let(:path) { '/v3/orders' }
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Ask'
        }
      end
      let(:payload) { "POST#{path}#{timestamp}#{body_params.to_json}" }
      let(:request_body) { body_params.map { |key, value| "#{key}=#{value}" }.join('&') }

      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: request_body,
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
      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end
  end
end
