# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Client do
  describe '#public_send' do
    context 'normal return' do
      subject { described_class.public_send }
      let(:response) { { "time": Time.now.to_s } }

      let!(:stud) do
        stub_request(:get, "#{BASE_URI}/")
          .to_return_200_with(response.to_json)
      end

      it { expect(subject[:body]).to eq response.to_json }
    end

    context '400 return' do
      let(:response) { { 'code': 'unsupport value', 'message': 'error message' } }

      let!(:stud) do
        stub_request(:get, "#{BASE_URI}/")
          .to_return_400_with(response.to_json)
      end

      it { expect { described_class.public_send }.to raise_error BTCMarkets::Error }
    end

    context '404 return' do
      let(:response) { { 'code': 'not found', 'message': 'error message' } }

      let!(:stud) do
        stub_request(:get, "#{BASE_URI}/")
          .to_return_404_with(response.to_json)
      end
      it { expect { described_class.public_send }.to raise_error BTCMarkets::Error }
    end
  end
end
