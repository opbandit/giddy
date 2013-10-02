module Giddy
  class Endpoint
    def initialize(mediator, path, secure)
      @mediator = mediator
      @path = path
      @secure = secure
    end

    def gettyup(name, data, bodyname=nil, secure=false)
      @mediator.gettyup @path, name, data, bodyname, @secure
    end
  end
end
