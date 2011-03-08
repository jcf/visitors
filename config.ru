require File.expand_path('../lib/visitors/server', __FILE__)

ROOT_DIR = File.expand_path('../lib/visitors/server', __FILE__)

Visitors::Server.default_options.merge!(
  :run    => false,
  :public => "#{ROOT_DIR}/public",
  :views  => "#{ROOT_DIR}/views",
  :env    => ENV['RACK_ENV']
)

run Visitors::Server
