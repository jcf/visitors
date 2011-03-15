require 'spec_helper'

describe Visitors do
  describe '#find' do
    context 'with a disabled environment' do
      it 'returns immediately' do
        Visitors.config.stub!(:disabled => true)
        Visitors::Resource.should_not_receive(:find)
        Visitors.find(1).should be_nil
      end
    end
  end

  describe '#increment' do
    context 'with a disabled environment' do
      it 'returns immediately' do
        Visitors.config.stub!(:disabled => true)
        Visitors::Resource.should_not_receive(:new)
        Visitors.increment(1, :show).should be_nil
      end
    end
  end
end
