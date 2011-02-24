require 'redis'
require 'redis-namespace'

class Visitors::Store
  attr_reader :redis, :namespace

  def initialize(namespace, redis_config)
    @redis = Redis.new(redis_config)
    @namespace = Redis::Namespace.new(namespace, :redis => @redis)
  end

  def find(business_id)
    namespace.hgetall business_id
  end

  def increment(business_id, type)
    namespace.hincrby business_id, type, 1
  end

  alias :incr :increment

  def method_missing(message, *args, &block)
    if namespace.respond_to?(message)
      namespace.send(message, *args, &block)
    else
      super(message, *args, &block)
    end
  end
end
