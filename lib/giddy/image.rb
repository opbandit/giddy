module Giddy
  class Image
    def initialize(attrs)
      if attrs.has_key?(:image_id) and attrs.keys.length == 1
        attrs = Search.get_image_details(attrs[:image_id]).first
      end      
      @attrs = Utils.rubified_hash(attrs)
    end

    def method_missing(method, *args, &block)
      @attrs.fetch(method, nil)
    end

    def largest_available
      result = Download.get_largest_image_download_authorizations(@attrs[:image_id])
      result[@attrs[:image_id]]
    end

    def download_request(token)
      result = Download.create_download_request(token)
      result[@attrs[:image_id]]
    end

    def download_largest
      authorizations = largest_available[:authorizations]
      return nil if authorizations.length == 0
      download_request authorizations.first[:download_token]
    end

    def self.find(attrs)
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
      Search.search_for_images(attrs)
    end

    def to_s
      as = @attrs.map { |k,v| "#{k}=#{v}" }.join(", ")
      "<Image #{as}>" 
    end
  end
end
