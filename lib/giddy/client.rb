module Giddy
  class Client
    def initialize(username, password, token=nil, secure_token=nil)
      @mediator = Mediator.new(username, password, token, secure_token)
    end

    def search(attrs)
      if attrs.has_key?(:image_id) and attrs.keys.length == 1
        return Search.new(@mediator).get_image_details(attrs[:image_id]).first
      end
      
      attrs = {
        :limit => 25,
        :start => 1,
        :query => "",
        :additional => {}
      }.merge(attrs)

      converted = {
        :Query => { :SearchPhrase =>  attrs[:query] },
        :ResultOptions => { :ItemCount => attrs[:limit], :ItemStartNumber => attrs[:start] }
      }
      attrs = attrs[:additional].merge(converted)
      Search.new(@mediator).search_for_images(attrs)
    end

    def token
      @mediator.token
    end

    def secure_token
      @mediator.secure_token
    end

    # not necessary typically, sessions will be autocreated
    def create_session
      @mediator.create_session
    end
  end
end
