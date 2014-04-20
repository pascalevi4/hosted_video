# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hosted_video/version'

Gem::Specification.new do |spec|
  spec.name          = "hosted_video"
  spec.version       = HostedVideo::VERSION
  spec.authors       = ["Vadim Alekseev"]
  spec.email         = ["vadim.alekseev777@gmail.com"]
  spec.description   = "desc"
  spec.summary       = "summary"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
