module Giddy
  class Search < Endpoint
    def initialize(mediator)
      super mediator, "search", false
    end

    def search_for_images(attrs)
      result = gettyup :SearchForImages, attrs, :SearchForImages2
      result["Images"].map { |attrs|
        Image.new(attrs, @mediator)
      }
    end
    
    def get_image_details(ids)
      attrs = { :ImageIds => [ids].flatten, :Language => 'en-us' }
      result = gettyup :GetImageDetails, attrs
      result["Images"].map { |attrs|
        Image.new(attrs, @mediator)
      }
    end
  end
end
