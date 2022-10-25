# frozen_string_literal: true

require 'burger'

RSpec.describe Burger do
  subject(:burger) { subject }

  describe '#cost' do
    it 'costs £5' do
      expect(burger.cost).to eq(500)
    end
  end
end
