module Giddy
  class LightboxHeaders < Endpoint
    def initialize(mediator)
      super mediator, "lightbox", false
    end

    def get_lightbox_headers(attrs)
      result = gettyup :GetLightboxHeaders, attrs
      result["LightboxHeaders"].map { |attrs|
        Lightbox.new(attrs, @mediator)
      }
    end

    def create_lightbox(attrs)
      result = gettyup :CreateLightbox, attrs
      Lightbox.new(result, @mediator)
    end

    def get_lightbox(attrs)
      result = gettyup :GetLightbox, attrs
      Lightbox.new(result["Lightbox"], @mediator)
    end
  end
end
