module Giddy
  class ImageNotFound < RuntimeError
  end

  class InvalidRequest < RuntimeError
  end

  class InvalidUsernameOrPassword < RuntimeError
  end

  class ImageDownloadError < RuntimeError
  end
end
