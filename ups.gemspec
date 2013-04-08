# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ups/version'

Gem::Specification.new do |spec|
  spec.name          = "ups"
  spec.version       = Ups::VERSION
  spec.authors       = ["Blake Williams"]
  spec.email         = ["blake@blakewilliams.me"]
  spec.description   = %q{Provide paid UPS shipping label generation}
  spec.summary       = %q{Provide paid UPS shipping label generation}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.10"
  spec.add_dependency "nokogiri", "~> 1.5"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
