require 'thor'

class Visitors::CLI < Thor
  desc 'store', 'start the redis in-memory store'
  def store
    say "You're running in development, do it yourself!", :blue
  end

  desc 'web', 'start the web console (NOT IMPLEMENTED)'
  def web
    require 'vegas'
    Vegas::Runner.new(Visitors::Server, 'visitors_app')
  end
end
