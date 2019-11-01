# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Market do
  BASE_URI = 'https://api.btcmarkets.net/v3'

  shared_examples 'a valid http request' do
    it 'should send api request' do
      subject
      expect(request_stub).to have_been_requested
    end
  end

  describe '.markets' do
    subject { described_class.markets }
    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}/markets")
        .to_return(status: 200, body: '{}')
    end

    include_examples 'a valid http request'
  end

  describe '.ticker' do
    subject { described_class.ticker('BTC-AUD') }

    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}/markets/BTC-AUD/ticker")
        .to_return(status: 200, body: '{}')
    end

    include_examples 'a valid http request'
  end
end
