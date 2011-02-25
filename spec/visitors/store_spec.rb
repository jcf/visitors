require 'spec_helper'

describe Visitors::Store do
  def store(options = {})
    @store ||= Visitors::Store.new(options)
  end

  describe 'using config' do
    context 'without an explicit namespace' do
      it 'defaults to Visitors config' do
        Visitors.stub!(:config => double('config', :redis_namespace => 'woot'))
        Visitors::Store.new.namespace.should == 'woot'
      end
    end
  end

  describe '#redis' do
    it 'sets up a redis store' do
      Redis.should_receive(:new).with(:foo => 'bar').and_return('redis')
      store(:namespace => 'namespace', :foo => 'bar').redis
    end
  end

  describe '#store' do
    it 'uses Redis::Namespace to wrap redis' do
      store(:namespace => 'namespace', :foo => 'bar').stub!(:redis => 'redis')
      Redis::Namespace.should_receive(:new).with('namespace', :redis => 'redis').and_return('namespace')
      store.store
    end
  end

  describe '#find' do
    it 'tries to find a document by id' do
      store.store.should_receive(:hgetall).with('abc').and_return(nil)
      store.find('abc')
    end
  end

  describe '#increment' do
    context 'with a valid field' do
      before(:each) do
        Visitors.stub!(:assert_valid_field! => true)
      end

      context 'with a business id that is not in the log' do
        it 'stores the id of the business and increments the field' do
          store.store.should_receive(:sadd).with('document_ids', '123').and_return(true)
          store.store.should_receive(:hincrby).with('123', 'show', 1).and_return(true)
          store.increment('123', 'show')
        end
      end
    end
  end
end
