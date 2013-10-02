module Giddy

  class Config
    def self.required_fields
      [ :system_id, :system_password ]
    end
    
    # system specific information
    attr_accessor :system_id, :system_password
    
    def check!
      self.class.required_fields.each do |required_field|
        unless send(required_field)
          raise "#{required_field} must be set in config"
        end
      end
    end
  end

end
