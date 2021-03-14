require 'rack'
require 'thin'
require 'erb'

handler = Rack::Handler::Thin

class Gambiarra
  attr_accessor :request, :routes

  def call(env)
    @request = env

    map_routes

    [200, { "Content-Type" => "text/html" }, response]
  end

  def map_routes
    @routes = [
      {
        method: "GET",
        path: "/",
        server: MyApp
      }
    ]
  end

  def route(method:, path:)
    puts "*** method: #{method}, path: #{path}"
    route = @routes.find { |route| route[:method].downcase == method.downcase && route[:path].downcase == path.downcase }
    if route
      render = route[:server].new.serve
      render
    else
      "<html><body><p>Oops</p></body></html>"
    end
  end

  def response
    route(method: @request['REQUEST_METHOD'], path: @request['REQUEST_PATH'])
  end
end

class MyApp
  def serve
    # https://blog.revathskumar.com/2014/10/ruby-rendering-erb-template.html
    ERB.new(File.read("./index.html.erb")).result(binding)
  end
end

handler.run Gambiarra.new
