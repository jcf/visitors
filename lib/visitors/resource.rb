class Visitors::Resource
  include Helpers
  extend  Helpers

  MONTHS = (1..12).to_a

  class << self
    def find(resource_id)
      Hash[*MONTHS.map do |month|
        [month, stats_for(new(resource_id, month).to_redis_key)]
      end.flatten]
    end

    def increment(resource_id, field)
      new(resource_id).increment(field)
    end

    alias :incr :increment
  end

  attr_reader :id, :date

  def initialize(id, date = nil)
    raise ArgumentError, 'Invalid id' unless id
    @id   = id
    @date = parse_date(date)
  end

  def to_redis_key
    [id, date].join(':')
  end

  alias :key :to_redis_key

  def increment(field)
    assert_valid_field!(field.to_sym)

    redis.sadd(SET_NAME, id)
    redis.hincrby(key, field, 1)
  end
end
