require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, 'postgres://localhost/visitors')

%w[Day Month Year].each do |class_name|
  Object.class_eval <<-RUBY, __FILE__, __LINE__ + 1
    class Visitors::#{class_name}
      include DataMapper::Resource

      property :id,       Serial
      property :archived, Time

      Visitors.fields.each do |field|
	property field, Integer, :default => 0, :required => true
      end
    end
  RUBY
end

DataMapper.finalize
DataMapper.auto_migrate!
