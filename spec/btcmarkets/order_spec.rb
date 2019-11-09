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

  shared_examples 'raise error' do
    it { expect { subject }.to raise_error BTCMarkets::Error }
  end

  describe '#create' do
    let(:path) { '/v3/orders' }
    let(:payload) { "POST#{path}#{timestamp}#{body_params.to_json}" }
    let(:request_body) { body_params.map { |key, value| "#{key}=#{URI.encode(value)}" }.join('&') }

    let!(:request_stub) do
      stub_request(:post, "#{BASE_URI}#{path}")
        .with(
          body: body_params.to_json,
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

    context 'buy a limit order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Bid'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a limit order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Ask'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a market order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Market',
          'side': 'Ask'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a stop limit order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Stop Limit',
          'side': 'Ask'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a stop order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Stop',
          'side': 'Ask'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'sell a take profit order' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Take Profit',
          'side': 'Ask'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'with all params' do
      let(:body_params) do
        {
          'marketId': 'BTC-AUD',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Take Profit',
          'side': 'Ask',
          'triggerPrice': '120000',
          'targetAmount': '0.1',
          'timeInForce': 'FOK',
          'postOnly': 'true',
          'selfTrade': 'A',
          'clientOrderId': 'order_1234567'
        }
      end

      subject { described_class.create(body_params) }
      include_examples 'a valid http request'
    end

    context 'without marketId' do
      let(:body_params) do
        {
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Ask'
        }
      end
      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: body_params.to_json,
            headers: {
              "Accept": 'application/json',
              "Accept-Charset": 'UTF-8',
              "Content-Type": 'application/json',
              "BM-AUTH-APIKEY": public_key,
              "BM-AUTH-TIMESTAMP": timestamp,
              "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
            }
          )
          .to_return_400
      end

      subject { described_class.create(body_params) }
      include_examples 'raise error'
    end

    context 'wrong marketId' do
      let(:body_params) do
        {
          'marketId': 'BTC',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Ask'
        }
      end
      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: body_params.to_json,
            headers: {
              "Accept": 'application/json',
              "Accept-Charset": 'UTF-8',
              "Content-Type": 'application/json',
              "BM-AUTH-APIKEY": public_key,
              "BM-AUTH-TIMESTAMP": timestamp,
              "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
            }
          )
          .to_return_400
      end

      subject { described_class.create(body_params) }
      include_examples 'raise error'
    end

    context 'insufficient funds' do
      let(:body_params) do
        {
          'marketId': 'BTC',
          'price': '10000.00',
          'amount': '100',
          'type': 'Limit',
          'side': 'Bid'
        }
      end
      let(:response) { { 'code': 'InsufficientFund', 'message': 'Insufficient fund' } }

      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: body_params.to_json,
            headers: {
              "Accept": 'application/json',
              "Accept-Charset": 'UTF-8',
              "Content-Type": 'application/json',
              "BM-AUTH-APIKEY": public_key,
              "BM-AUTH-TIMESTAMP": timestamp,
              "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
            }
          )
          .to_return_400_with(response.to_json)
      end

      subject { described_class.create(body_params) }
      include_examples 'raise error'
    end

    context 'insufficient api permission' do
      let(:body_params) do
        {
          'marketId': 'BTC',
          'price': '10000.00',
          'amount': '0.1',
          'type': 'Limit',
          'side': 'Ask'
        }
      end
      let!(:request_stub) do
        stub_request(:post, "#{BASE_URI}#{path}")
          .with(
            body: body_params.to_json,
            headers: {
              "Accept": 'application/json',
              "Accept-Charset": 'UTF-8',
              "Content-Type": 'application/json',
              "BM-AUTH-APIKEY": public_key,
              "BM-AUTH-TIMESTAMP": timestamp,
              "BM-AUTH-SIGNATURE": BTCMarkets::Authentication.signature(payload)
            }
          )
          .to_return_403
      end

      subject { described_class.create(body_params) }
      include_examples 'raise error'
    end
  end
end
