# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_faye/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_faye"
  spec.version       = SimpleFaye::VERSION
  spec.authors       = ["Derrick Yeung"]
  spec.email         = ["lscspirit@hotmail.com"]
  spec.summary       = %q{A simple Rails style wrapper around Faye Ruby server}
  spec.description   = %q{A Faye Ruby server extension providing simple Rails-style channel routing and message processing}
  spec.homepage      = "https://github.com/lscspirit/simple_faye"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faye", "~> 1.0"
  spec.add_dependency 'facets'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "thin", "~> 1.6"
end
