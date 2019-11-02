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
        .to_return(status: 200, body: json_fixture('markets'))
    end

    include_examples 'a valid http request'
  end

  describe '.ticker' do
    describe 'with pair' do
      let(:pair) { 'BTC-AUD' }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{pair}/ticker")
          .to_return(status: 200, body: json_fixture('ticker'))
      end
      subject { described_class.ticker(pair) }
      include_examples 'a valid http request'
    end

    describe 'without pair' do
      let(:pair) { nil }
      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{pair}/ticker")
          .to_return(status: 404, body: json_fixture('error_404'))
      end
      subject { described_class.ticker(pair) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end

    describe 'incorrect pair' do
      let(:pair) { 'not_exist_pair' }

      let!(:request_stub) do
        stub_request(:get, "#{BASE_URI}/markets/#{pair}/ticker")
          .to_return(status: 400, body: json_fixture('error_404'))
      end
      subject { described_class.ticker(pair) }

      it { expect { subject }.to raise_error BTCMarkets::Error }
      include_examples 'a valid http request'
    end
  end
end
