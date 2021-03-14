require 'rack'
require 'thin'
require 'erb'

require './router'
Router.init

# Require all main.rb from each feature
Dir["./features/**/main.rb"].each { |f| require(f) }

class Gambiarra
  attr_accessor :request, :routes

  def call(env)
    @request = env

    [200, { "Content-Type" => "text/html" }, response]
  end

  def route(method:, path:)
    puts "*** method: #{method}, path: #{path}"
    route = Router.routes.find { |route| route[:path].downcase == path.downcase }
    if route
      render = route[:server].new.process(method: method)
      render
    else
      "<html><body><p>Oops</p></body></html>"
    end
  end

  def response
    route(method: @request['REQUEST_METHOD'], path: @request['REQUEST_PATH'])
  end
end

# Example app
module ExampleApp
  class App
    def serve
      # https://blog.revathskumar.com/2014/10/ruby-rendering-erb-template.html
      ERB.new(File.read("./index.html.erb")).result(binding)
    end
  end
end

Rack::Handler::Thin.run Gambiarra.new
