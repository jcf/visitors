require 'thor'

class Visitors::CLI < Thor
  desc 'store', 'start the redis in-memory store'
  def store
    say "You're running in development, do it yourself!", :blue
  end

  desc 'web', 'start the web console (NOT IMPLEMENTED)'
  def web
    say 'Not implemented yet', :red
  end
end
