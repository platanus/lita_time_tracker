Gem::Specification.new do |spec|
  spec.name          = "lita_time_tracker"
  spec.version       = "0.1.0"
  spec.authors       = ["Leandro Segovia", "Cristian Moreno"]
  spec.email         = ["leandro@platan.us", "khriztian@platan.us"]
  spec.description   = "Get time tracking information in your Slack"
  spec.summary       = "Get Toggle or Harvest information in your Slack"
  spec.homepage      = "https://platan.us"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "awesome_print"
  spec.add_dependency "togglv8"
  spec.add_dependency "httparty"
  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
