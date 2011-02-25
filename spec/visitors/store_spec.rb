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

  describe '#redis_connection' do
    it 'sets up a redis store' do
      Redis.should_receive(:new).with(:foo => 'bar').and_return('redis')
      store(:namespace => 'namespace', :foo => 'bar').redis
    end
  end

  describe '#redis' do
    it 'uses Redis::Namespace to wrap redis' do
      Redis.stub!(:new => double('redis'))
      store(:namespace => 'namespace', :foo => 'bar')
      store.redis.should be_a(Redis::Namespace)
    end
  end

  describe '#find' do
    it 'tries to find a resource by id' do
      store.redis.should_receive(:hgetall).with('abc').and_return(nil)
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
          store.redis.should_receive(:sadd).with('resource_ids', '123').and_return(true)
          store.redis.should_receive(:hincrby).with('123', 'show', 1).and_return(true)
          store.increment('123', 'show')
        end
      end
    end
  end
end
