# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Market do

  BASE_URI = 'https://api.btcmarkets.net/v3'

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
      stub_request(:get, "#{BASE_URI}/markets")
        .to_return_200_with(json_fixture('markets'))
    end

    include_examples 'a valid http request'
  end

  describe '.ticker' do
    describe 'with market_id' do
      let(:market_id) { 'BTC-AUD' }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{market_id}/ticker")
          .to_return_200_with(json_fixture('ticker'))
      end
      subject { described_class.ticker(market_id) }
      include_examples 'a valid http request'
    end

    describe 'without market_id' do
      let(:market_id) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{market_id}/ticker")
          .to_return_404_with(json_fixture('error_404'))
      end
      subject { described_class.ticker(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'incorrect market_id' do
      let(:market_id) { 'not_exist_market_id' }

      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{market_id}/ticker")
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
        stub_request(:get, "#{BASE_URI}/markets/#{market_id}/trades")
          .to_return_400_with(json_fixture('error_400'))
      end
      subject { described_class.trades(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'without market_id' do
      let(:market_id) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{market_id}/trades")
          .to_return_404_with(json_fixture('error_404'))
      end
      subject { described_class.trades(market_id) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end
  end
end
