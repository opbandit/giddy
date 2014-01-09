module Giddy
  class Lightbox
    def initialize(attrs, mediator)
      @attrs = Utils.rubified_hash(attrs)
      @mediator = mediator
    end

    def images
      lightbox_items
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
