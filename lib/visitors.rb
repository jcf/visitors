$:.push File.expand_path('..', __FILE__)

module Visitors
  extend self

  autoload :Store, 'visitors/store'
  autoload :Day,   'visitors/models'
  autoload :Month, 'visitors/models'
  autoload :Year,  'visitors/models'

  FIELDS = [:show, :search, :email, :website]

  def fields
    FIELDS
  end
end
