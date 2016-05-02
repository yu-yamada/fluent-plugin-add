# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'fluent/plugin/add/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-add"
  spec.version       = "0.0.6" 
  spec.authors       = ["yu yamada"]
  spec.email         = ["yu.yamada07@gmail.com"]
  spec.description   = %q{Output filter plugin to add messages} 
  spec.summary       =  %q{Output filter plugin to add messages} 
  spec.homepage      = "https://github.com/yu-yamada/fluent-plugin-add"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit", "~> 3.1.0"
  spec.add_runtime_dependency "fluentd"
end
