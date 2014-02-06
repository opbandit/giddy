module Giddy
  class Client
    def initialize(username, password, token=nil, secure_token=nil)
      @mediator = Mediator.new(username, password, token, secure_token)
    end

    def set_system_credentials(system_id, system_password)
      @mediator.set_system_credentials system_id, system_password
    end

    def search(attrs)
      if attrs.has_key?(:image_id) and attrs.keys.length == 1
        return Search.new(@mediator).get_image_details(attrs[:image_id]).first
      elsif attrs.has_key?(:image_ids) and attrs.keys.length == 1
        return Search.new(@mediator).get_image_details(attrs[:image_ids])
      end
      
      attrs = {
        :limit => 25,
        :start => 1,
        :query => "",
        :sort_by => 'MostPopular',
        :additional => {}
      }.merge(attrs)

      converted = {
        :Filter => { :ImageFamilies => ['Creative']},
        :Query => { :SearchPhrase =>  attrs[:query] },
        :ResultOptions => { :ItemCount => attrs[:limit], :ItemStartNumber => attrs[:start], :CreativeSortOrder => attrs[:sort_by] }
      }
      attrs = converted.merge(attrs[:additional])
      Search.new(@mediator).search_for_images(attrs)
    end

    def lightboxes(count=20, start=1)
      attrs = {
        :ResultsViewOptions => { :ItemCount => count, :ItemStartNumber => start }
      }
      LightboxHeaders.new(@mediator).get_lightbox_headers(attrs)
    end

    def get_lightbox(id, count=20, start=1)
      # Yes, this just returns info for a lightbox, but you can control the list of images
      # in this lightbox with the pagination parameters
      attrs = { :LightboxId => id, :LightboxItemsViewOptions => { :ItemCount => count, :ItemStartNumber => start } }
      LightboxHeaders.new(@mediator).get_lightbox(attrs)
    end

    def create_lightbox(name, attrs)
      attrs = { :LightboxName => name }.merge(attrs)
      LightboxHeaders.new(@mediator).create_lightbox(attrs)
    end

    def token
      @mediator.token
    end

    def secure_token
      @mediator.secure_token
    end

    # not necessary typically, sessions will be autocreated
    def create_session
      @mediator.create_session
    end
  end
end
