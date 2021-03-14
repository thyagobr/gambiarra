class Router
  class << self
    attr_accessor :routes

    def init
      @routes = []
    end

    def draw(&block)
      instance_eval(&block)
    end
  end
end
