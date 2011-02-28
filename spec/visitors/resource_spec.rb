require 'spec_helper'

describe Visitors::Resource do
  def resource(id = nil, date = nil)
    @resource ||= Visitors::Resource.new(id, date)
  end

  describe '#key' do
    context 'with an integer id' do
      context 'with no date' do
        it 'returns the resource id and the current date' do
          Time.stub!(:now => double('time', :strftime => '0311'))
          resource(1).key.should == '1:0311'
        end
      end

      context 'with a timestamp of the form mmyy' do
        it 'uses the id and the supplied timestamp' do
          resource(1, '0311').key.should == '1:0311'
        end
      end

      context 'with a nil date' do
        it 'ignores the date and returns the id with the current date' do
          Time.stub!(:now => double('time', :strftime => '0311'))
          resource(1, nil).key.should == '1:0311'
        end
      end
    end
  end

  context 'with no id' do
    it 'returns an empty key' do
      expect { resource(nil).key }.to raise_error(ArgumentError)
    end
  end
end
