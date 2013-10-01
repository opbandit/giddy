module Giddy
  class Utils
    # covert camel case keys to underscore
    def self.rubified_hash(h)
      if h.is_a?(Array)
        return h.map { |v| rubified_hash(v) }
      elsif not h.is_a?(Hash)
        return h
      end

      fixed = {}
      h.each { |key, value|
        key = key.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
        fixed[key.intern] = rubified_hash(value)
      }
      fixed
    end
  end
end
