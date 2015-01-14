# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gauze/version'

Gem::Specification.new do |spec|
  spec.name          = "gauze"
  spec.version       = Gauze::VERSION
  spec.authors       = ["Chris Ostrowski"]
  spec.email         = ["chris@madebyfunction.com"]
  spec.summary       = %q{A thin filtering library leveraging AREL & ActionController.}
  spec.description   = %q{Using scopes on a model that only need to accessed in a controller seems like a leakage of SRP. This gem will allow you to write simple filtering logic that translates your params to AREL queries.}
  spec.homepage      = "https://github.com/TheKidCoder/Gauze"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.2.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
