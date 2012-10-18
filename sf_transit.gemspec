$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sf_transit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sf_transit"
  s.version     = SFTransit::VERSION
  s.authors     = ["Ben Bergstein"]
  s.email       = ["bennyjbergstein@gmail.com"]
  s.summary     = "Easily pull data, cross reference stops and make use of freely available transit resources."
  s.description = "Leverage BART and SF Muni web services within Rails appliations."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"
  s.add_dependency 'geocoder'
  s.add_dependency 'next_muni'

  s.add_development_dependency "pg"
end
