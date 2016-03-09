# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotdiff/version'

Gem::Specification.new do |spec|
  spec.name          = "dotdiff"
  spec.version       = Dotdiff::VERSION
  spec.authors       = ["Jon Normington"]
  spec.email         = ["jnormington@users.noreply.github.com"]

  spec.summary       = "Preceptual diff wrapper for capybara and rspec regression specs"
  spec.description   = "Creating base_image and generating new images to compare to"
  spec.homepage      = "https://github.com/jnormington/dotdiff"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
