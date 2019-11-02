# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BTCMarkets::Error do
  describe '#error_response?' do
    context 'response 200' do
      let(:response) { double('response', code: 200) }
      it { expect(described_class.error_response?(response)).to eq false }
    end

    context 'response 400' do
      let(:response) { double('response', code: 400) }
      it { expect(described_class.error_response?(response)).to eq true }
    end

    context 'response 500' do
      let(:response) { double('response', code: 500) }
      it { expect(described_class.error_response?(response)).to eq true }
    end
  end
end
