module Giddy
  class Search
    extend Mediator

    def self.path
      "search"
    end

    def self.search_for_images(attrs)
      result = gettyup :SearchForImages, attrs, :SearchForImages2
      result["Images"].map { |attrs|
        Image.new(attrs)
      }
    end
    
    def self.get_image_details(ids)
      attrs = { :ImageIds => [ids].flatten, :Language => 'en-us' }
      result = gettyup :GetImageDetails, attrs
      result["Images"]
    end
  end
end
