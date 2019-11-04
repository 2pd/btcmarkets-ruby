# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Server do
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

  describe '#time' do
    subject { described_class.time }

    let!(:request_stub) do
      stub_request(:get, "#{BASE_URI}/v3/time")
        .to_return_200_with('{"timestamp": "2019-09-01T18:34:27.045000Z"}'.to_json)
    end

    include_examples 'a valid http request'
  end
end
