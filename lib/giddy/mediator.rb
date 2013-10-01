module Giddy
  module Mediator
    ROOTPATH = "https://connect.gettyimages.com/v1"
    
    def gettyup(name, data, bodyname=nil, secure=false, check_token=true)
      token = secure ? Giddy.config.secure_token : Giddy.config.token
      if token.nil? and check_token
        Session.create_session
        token = secure ? Giddy.config.secure_token : Giddy.config.token
      end

      result = fetch(token, bodyname, name, data)

      if reauth_needed?(result)
        Session.create_session
        gettyup name, data, bodyname        
      elsif result["ResponseHeader"]["Status"] == "success"
        result["#{name}Result"]
      else
        raise "Error fetching #{name}: #{result["ResponseHeader"]}"
      end
    end

    def fetch(token, bodyname, name, data)
      body = { :RequestHeader => { :Token => token }, "#{bodyname || name}RequestBody" => data }
      headers = { 'Content-Type' => 'application/json' }
      url = "#{ROOTPATH}/#{path}/#{name}"
      result = HTTParty.post(url, :body => body.to_json, :headers => headers)
      puts "body: #{body.to_json}\n result: #{result.body}\n\n"
      result
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
