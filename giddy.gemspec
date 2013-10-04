$:.push File.expand_path("../lib", __FILE__)
require "giddy/version"

Gem::Specification.new do |s|
  s.name        = "giddy"
  s.version     = Giddy::VERSION
  s.authors     = ["Brian Muller"]
  s.email       = ["bamuller@gmail.com"]
  s.homepage    = "https://github.com/opbandit/giddy"
  s.summary     = "Ruby client for Getty API"
  s.description = "Ruby client for Getty API"
  s.license     = 'MIT'

  s.rubyforge_project = "giddy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("httparty", ">= 0.11.0")
  s.add_dependency("json", ">= 1.8.0")
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake')
end
