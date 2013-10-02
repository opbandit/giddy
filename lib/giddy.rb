require 'json'
require 'httparty'

require "giddy/version"
require "giddy/endpoint"
require "giddy/config"
require "giddy/mediator"
require "giddy/client"
require "giddy/search"
require "giddy/download"
require "giddy/image"
require "giddy/utils"

module Giddy
  def self.config
    @config ||= Config.new
  end

  def self.setup(&block)
    yield config
    config.check!
  end
end
