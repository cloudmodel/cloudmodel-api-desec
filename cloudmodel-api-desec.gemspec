require_relative "lib/cloud_model/api/desec/version"

Gem::Specification.new do |spec|
  spec.name        = "cloudmodel-api-desec"
  spec.version     = CloudModel::Api::Desec::VERSION
  spec.authors     = ["Sven G. Brönstrup (StarPeak)"]
  spec.email       = ["info@cloud-model.org"]
  spec.homepage    = "http://cloud-model.org/"
  spec.summary     = "Desec DNS API support for CloudModel"
  spec.description = "Support for Desec DNS API in CloudModel."
  spec.license     = 'MIT'


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cloudmodel/cloudmodel-api-desec"
  spec.metadata["changelog_uri"] = "https://github.com/cloudmodel/cloudmodel-api-desec/commits/master"


  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.0.3.4"
  spec.add_dependency 'cloudmodel', '~> 0.2.1'
end
