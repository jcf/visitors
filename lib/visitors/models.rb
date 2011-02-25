require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, Visitors.config.database)

MODEL_NAMES = %w[Day Month Year]

MODEL_NAMES.each do |class_name|
  Visitors.class_eval <<-RUBY, __FILE__, __LINE__ + 1
    class Visitors::#{class_name}
      include DataMapper::Resource

      property :id,          Serial
      property :archived,    Time
      property :resource_id, Integer, :required => true

      Visitors.fields.each do |field|
        property field, Integer, :default => 0, :required => true
      end
    end
  RUBY
end

DataMapper.finalize
DataMapper.auto_migrate!
