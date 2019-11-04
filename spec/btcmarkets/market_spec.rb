# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Market do
  shared_examples 'a valid http request' do
    it 'should send api request' do
      begin
        subject
      rescue StandardError
        BTCMarkets::Error
      end

      expect(request_stub).to have_been_requested
    end
  end

  describe '.markets' do
    subject { described_class.markets }
    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}/v3/markets")
        .to_return_200_with(json_fixture('markets'))
    end

    include_examples 'a valid http request'
  end

  describe '.ticker' do
    describe 'with market_id' do
      let(:market_id) { 'BTC-AUD' }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/ticker")
          .to_return_200_with(json_fixture('ticker'))
      end
      subject { described_class.ticker(market_id) }
      include_examples 'a valid http request'
    end

    describe 'without market_id' do
      let(:market_id) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/ticker")
          .to_return_404_with(json_fixture('error_404'))
      end
      subject { described_class.ticker(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'incorrect market_id' do
      let(:market_id) { 'not_exist_market_id' }

      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/ticker")
          .to_return_400_with(json_fixture('error_400'))
      end
      subject { described_class.ticker(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end
  end

  describe '#trades' do
    describe 'with incorrect market_id' do
      let(:market_id) { 'not_exist' }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/trades")
          .to_return_400_with(json_fixture('error_400'))
      end
      subject { described_class.trades(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'without market_id' do
      let(:market_id) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/trades")
          .to_return_404_with(json_fixture('error_404'))
      end
      subject { described_class.trades(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'with market_id' do
      let(:market_id) { 'BTC-AUD' }
      let(:before) { '78234976' }
      let(:after) { '78234876' }
      let(:limit) { 10 }
      let(:query_params) { { 'before' => before, 'after' => after, 'limit' => limit } }

      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/trades")
          .with(query: query_params)
          .to_return_200_with(json_fixture('trades'))
      end
      subject { described_class.trades(market_id, query_params) }

      include_examples 'a valid http request'
    end
  end

  describe '#orderbook' do
    describe 'with out market_id' do
      let(:market_id) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/orderbook")
          .to_return_404_with(json_fixture('error_404'))
      end
      subject { described_class.orderbook(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'with incorrect market_id' do
      let(:market_id) { 'not_exist' }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/orderbook")
          .to_return_400_with(json_fixture('error_400'))
      end
      subject { described_class.orderbook(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'with market_id' do
      let(:market_id) { 'BTC-AUD' }
      let(:level) { 1 }
      let(:query_params) { { 'level' => level } }

      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/#{market_id}/orderbook")
          .with(query: query_params)
          .to_return_200_with(json_fixture('orderbook'))
      end

      subject { described_class.orderbook(market_id, query_params) }
      include_examples 'a valid http request'
    end
  end

  describe '#tickers' do
    describe 'all tickers' do
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/tickers")
          .to_return_200
      end
      subject { described_class.tickers }
      include_examples 'a valid http request'
    end

    describe 'with given tickers' do
      let(:query_params) { %w[BTC-AUD LTC-AUD] }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/tickers")
          .with(query: hash_including('marketId' => query_params))
          .to_return_200
      end

      subject { described_class.tickers(query_params) }
      include_examples 'a valid http request'
    end
  end

  describe '#orderbooks' do
    describe 'all orderbooks' do
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/orderbooks")
          .to_return_200
      end
      subject { described_class.orderbooks }
      include_examples 'a valid http request'
    end

    describe 'with given tickers' do
      let(:query_params) { %w[BTC-AUD LTC-AUD] }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/v3/markets/orderbooks")
          .with(query: hash_including('marketId' => query_params))
          .to_return_200
      end

      subject { described_class.orderbooks(query_params) }
      include_examples 'a valid http request'
    end
  end
end
