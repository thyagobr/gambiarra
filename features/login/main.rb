module Mesmer
  class App
    def process(method:)
      send(method.downcase)
    end

    def get
      # https://blog.revathskumar.com/2014/10/ruby-rendering-erb-template.html
      # By the way, this file will be loaded by /main.rb, that's why I have to indicate the path to the feature here
      ERB.new(File.read("./features/login/index.html.erb")).result(binding)
    end

    def post
      "Processing post..."
    end
  end
end

Router.draw do
  @routes << {
    method: "GET",
    path: "/",
    server: Mesmer::App
  }
end
