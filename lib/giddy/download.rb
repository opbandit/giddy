module Giddy
  class Download
    extend Mediator

    def self.path
      "download"
    end

    def self.search_for_images(attrs)
      result = gettyup :SearchForImages, attrs, :SearchForImages2
      result["Images"].map { |attrs|
        Image.new(attrs)
      }
    end
    
    def self.get_largest_image_download_authorizations(ids)
      ids = [ids].flatten.map { |id| { :ImageId => id } }
      result = gettyup :GetLargestImageDownloadAuthorizations, { :Images => ids }
      result["Images"].inject({}) { |h,i| h[i["ImageId"]] = Utils.rubified_hash(i); h }
    end

    def self.create_download_request(tokens)
      tokens = [tokens].flatten.map { |token| { :DownloadToken => token } }
      result = gettyup :CreateDownloadRequest, { :DownloadItems => tokens }, "CreateDownload", true
      result["DownloadUrls"].inject({}) { |h,i| h[i["ImageId"]] = Utils.rubified_hash(i); h }
    end
  end
end
