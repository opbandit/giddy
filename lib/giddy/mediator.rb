module Giddy
  class Mediator
    ROOTPATH = "https://connect.gettyimages.com/v1"
    attr_reader :token, :secure_token
    
    def initialize(username, password, token=nil, secure_token=nil)
      @username = username
      @password = password
      @token = token
      @secure_token = secure_token
      @system_id = nil
      @system_password = nil
    end

    def set_system_credentials(system_id, system_password)
      @system_id = system_id
      @system_password = system_password
    end

    def create_session
      data = { 
        :SystemId => @system_id || Giddy.config.system_id,
        :SystemPassword => @system_password || Giddy.config.system_password,
        :UserName => @username,
        :UserPassword => @password
      }
      result = fetch "session", nil, nil, :CreateSession, data
      unless result["ResponseHeader"]["Status"] == "success"
        raise error_type(result), "Error authenticating: #{result["ResponseHeader"]}"
      end
      @token = result["CreateSessionResult"]["Token"]
      @secure_token = result["CreateSessionResult"]["SecureToken"]
    end

    def gettyup(path, name, data, bodyname, secure)
      token = secure ? @secure_token : @token
      if token.nil?
        create_session
        token = secure ? @secure_token : @token
      end

      result = fetch(path, token, bodyname, name, data)

      if reauth_needed?(result)
        create_session
        gettyup path, name, data, bodyname, secure
      elsif result["ResponseHeader"]["Status"] == "success"
        result["#{name}Result"]
      else
        raise error_type(result), "Error fetching #{name}: #{result["ResponseHeader"]}"
      end
    end

    def error_type(result)
      statuses = result["ResponseHeader"]["StatusList"].map { |s| s["Code"] }
      return ImageNotFound if statuses.include? "ImageNotFound"
      return InvalidUsernameOrPassword if statuses.include? "InvalidUsernameOrPassword"
      InvalidRequest
    end

    def fetch(path, token, bodyname, name, data)
      body = { :RequestHeader => { :Token => token }, "#{bodyname || name}RequestBody" => data }
      headers = { 'Content-Type' => 'application/json' }
      url = "#{ROOTPATH}/#{path}/#{name}"
      HTTParty.post(url, :body => body.to_json, :headers => headers)
    end

    def reauth_needed?(result)
      return true if result.body == "<h1>Developer Inactive</h1>"
      reauth_codes = [ "AUTH-012", "AUTH-010" ]
      if result["ResponseHeader"]["StatusList"].length > 0
        reauth_codes.include? result["ResponseHeader"]["StatusList"].first["Code"]
      else
        false
      end
    end
  end
end
