module Giddy

  class Config
    def self.required_fields
      [ :system_id, :system_password, :username, :password ]
    end
    
    # system specific information
    attr_accessor :system_id, :system_password
    
    # user specific information
    attr_accessor :username, :password

    # session information
    attr_accessor :token, :secure_token

    def check!
      self.class.required_fields.each do |required_field|
        unless send(required_field)
          raise MissingConfigurationError, "#{required_field} must be set"
        end
      end
    end

    def clear_session
      @token = nil
      @secure_token = nil
    end
  end

end
