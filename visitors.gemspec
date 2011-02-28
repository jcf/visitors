# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'visitors/version'

Gem::Specification.new do |s|
  s.name        = 'visitors'
  s.version     = Visitors::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['James Conroy-Finn']
  s.email       = ['james@logi.cl']
  s.homepage    = 'http://github.com/jcf/visitors'
  s.summary     = %q{All-in-one fast logging system for your Rails application}
  s.description = %q{Redis-backed activity storage to track visits to different parts of your Ruby web app in real-time.}

  s.rubyforge_project = 'visitors'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  {
    'redis'               => '2.1.1',
    'redis-namespace'     => '0.10.0',
    'sinatra'             => '1.1.3',
    'thor'                => '0.14.6',
    'haml'                => '3.0.25',
    'vegas'               => '0.1.8'
  }.each { |gem, version| s.add_dependency gem, "~> #{version}" }

  {
    'rspec'       => '2.5.0',
    'guard-rspec' => '0.1.9',
    'rb-fsevent'  => '0.3.10',
    'shotgun'     => '0.9'
  }.each { |gem, version| s.add_development_dependency gem, "~> #{version}" }
end
