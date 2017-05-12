Gem::Specification.new do |spec|
  spec.name          = "lita-toggl"
  spec.version       = "0.2.0"
  spec.authors       = ["Leandro segovia", "Cristian Moreno"]
  spec.email         = ["leandro@platan.us", "khriztian@platan.us"]
  spec.description   = "Toggl Slack Status"
  spec.summary       = "Sets your Slack status to the given toggl"
  spec.homepage      = "https://platan.us"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "google_drive"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "rufus-scheduler"
end
