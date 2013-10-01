module Giddy
  class Session
    extend Mediator

    def self.path
      "session"
    end

    def self.create_session
      Giddy.config.clear_session
      data = { 
        :SystemId => Giddy.config.system_id,
        :SystemPassword => Giddy.config.system_password,
        :UserName => Giddy.config.username,
        :UserPassword => Giddy.config.password
      }
      result = gettyup :CreateSession, data, nil, false, false
      Giddy.config.token = result["Token"]
      Giddy.config.secure_token = result["SecureToken"]
    end
  end
end
