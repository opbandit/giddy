module Giddy
  class Image
    def initialize(attrs, mediator)
      @attrs = Utils.rubified_hash(attrs)
      @mediator = mediator
    end

    def method_missing(method, *args, &block)
      @attrs.fetch(method, nil)
    end

    def downloader
      @downloader ||= Download.new(@mediator)
    end

    # return sorted sizes, smallest to largest
    def sizes
      sizes_downloadable_images.sort { |a,b| a[:file_size_in_bytes] <=> b[:file_size_in_bytes] }
    end

    def download(size)
      sizekey = size[:size_key]
      result = downloader.get_image_download_authorizations(@attrs[:image_id], [sizekey])
      download_request result[sizekey][:authorizations].first[:download_token]
    end

    def largest_available
      result = downloader.get_largest_image_download_authorizations(@attrs[:image_id])
      result[@attrs[:image_id]]
    end

    def download_request(token)
      result = downloader.create_download_request(token)
      result[@attrs[:image_id]]
    end

    def download_largest
      authorizations = largest_available[:authorizations]
      return nil if authorizations.length == 0
      download_request authorizations.first[:download_token]
    end

    def to_s
      as = @attrs.map { |k,v| "#{k}=#{v}" }.join(", ")
      "<Image #{as}>" 
    end
  end
end
