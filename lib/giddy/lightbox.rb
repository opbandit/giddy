module Giddy
  class Lightbox
    def initialize(attrs, mediator)
      @attrs = Utils.rubified_hash(attrs)
      @mediator = mediator
    end

    def images
      image_ids = lightbox_items.map { |img| img[:asset_id] }
      Search.new(@mediator).get_image_details(image_ids)
    end

    def method_missing(method, *args, &block)
      @attrs.fetch(method, nil)
    end

    def to_s
      as = @attrs.map { |k,v| "#{k}=#{v}" }.join(", ")
      "<Lightbox #{as}>" 
    end
  end
end
