# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mn_model/version'

Gem::Specification.new do |spec|
  spec.name          = "mn_model"
  spec.version       = MnModel::VERSION
  spec.authors       = ["Andersen Fan"]
  spec.email         = ["as181920@hotmail.com"]
  spec.description   = %q{model for micro_notes}
  spec.summary       = %q{basic data logic}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "pg"
  spec.add_dependency 'activerecord', "4.0.0.beta1"#,"~>3.2.12"
  #spec.add_dependency 'activerecord', "~>3.2.12"

  spec.add_development_dependency "bundler" #, "~> 1.3"
  spec.add_development_dependency "rake"
  #spec.add_development_dependency "pg"
  #spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "rb-inotify"
end
