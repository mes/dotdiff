# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotdiff/version'

is_java = RUBY_PLATFORM == 'java'

Gem::Specification.new do |spec|
  spec.name          = "dotdiff"
  spec.version       = DotDiff::VERSION
  spec.authors       = ["Jon Normington"]
  spec.email         = ["jnormington@users.noreply.github.com"]
  spec.platform      = 'java' if is_java

  spec.summary       = "Image regression wrapper for Capybara and RSpec using image magick supporting both MRI and JRuby versions"
  spec.description   = [spec.summary, "which supports snap shoting both full page and specific elements on a page where text checks isn't enough"].join(' ')
  spec.homepage      = "https://github.com/jnormington/dotdiff"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if is_java
    spec.add_runtime_dependency "rmagick4j", '~> 0.4.0'
  else
    spec.add_runtime_dependency "mini_magick", '~> 4.9.4'
  end

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "capybara", "~> 2.6"
end
