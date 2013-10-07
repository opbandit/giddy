module Giddy
  class Download < Endpoint
    def initialize(mediator)
      super mediator, "download", true
    end

    def get_image_download_authorizations(image_id, sizes)
      images = sizes.map { |s| { :ImageId => image_id, :SizeKey => s } }
      result = gettyup :GetImageDownloadAuthorizations, { :ImageSizes => images }
      result["Images"].inject({}) { |h,i| h[i["SizeKey"]] = Utils.rubified_hash(i); h }
    end

    def get_largest_image_download_authorizations(ids)
      ids = [ids].flatten.map { |id| { :ImageId => id } }
      result = gettyup :GetLargestImageDownloadAuthorizations, { :Images => ids }
      result["Images"].inject({}) { |h,i| h[i["ImageId"]] = Utils.rubified_hash(i); h }
    end

    def create_download_request(tokens)
      tokens = [tokens].flatten.map { |token| { :DownloadToken => token } }
      result = gettyup :CreateDownloadRequest, { :DownloadItems => tokens }, "CreateDownload"
      result["DownloadUrls"].inject({}) { |h,i| h[i["ImageId"]] = Utils.rubified_hash(i); h }
    end
  end
end
