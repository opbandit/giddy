module Giddy
  class Download < Endpoint
    def initialize(mediator)
      super mediator, "download", true
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
