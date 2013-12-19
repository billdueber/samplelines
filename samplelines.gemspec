# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'samplelines/version'

Gem::Specification.new do |spec|
  spec.name          = "samplelines"
  spec.version       = Samplelines::VERSION
  spec.authors       = ["Bill Dueber"]
  spec.email         = ["bill@dueber.com"]
  spec.description   = %q{Simple command line utility to pick a random sample of lines out of the given file(s)}
  spec.summary       = %q{Simple command line utility to pick a random sample of lines out of the given file(s)}
  spec.homepage      = "http://github.com/billdueber/samplelines"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
