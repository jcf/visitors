require 'spec_helper'

describe Visitors do
  describe '.assert_valid_field!' do
    it 'protects against using unknown fields' do
      error_message = %{Invalid field "invalid_field". Valid fields are []}

      expect {
        Visitors.stub!(:fields => %w[])
        Visitors.assert_valid_field!('invalid_field')
      }.to raise_error(Visitors::UnsupportedField, error_message)
    end
  end
end
