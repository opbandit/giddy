require 'mechanize'
require 'cgi'

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

    def self.get_lightbox_ids(username, password)
      a = Mechanize.new
      a.get('https://secure.gettyimages.com/sign-in') do |page|
        page = page.form_with(:id => 'new_new_session') { |f|
          f["new_session[username]"] = username
          f["new_session[password]"] = password
        }.click_button

        return nil if page.filename != "index.html"
      end

      a.get('http://www.gettyimages.com/account/MediaBin/Default.aspx?ViewBy=0') do |page|
        return page.links_with(:id => 'hypMediaBinName').map { |l|
          CGI::parse(l.href.split('?')[1])['Id'][0]
        }
      end
    end

  end
end
