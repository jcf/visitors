require 'active_support'

$:.push File.expand_path('..', __FILE__)

module Visitors
  extend self

  autoload :Store, 'visitors/store'
  autoload :Day,   'visitors/business'
  autoload :Month, 'visitors/business'
  autoload :Year,  'visitors/business'

  FIELDS = [:show, :search, :email, :website]

  def fields
    FIELDS
  end
end
