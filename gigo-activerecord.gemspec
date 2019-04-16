# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gigo/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = "gigo-activerecord"
  spec.version       = GIGO::ActiveRecord::VERSION
  spec.authors       = ["Ken Collins"]
  spec.email         = ["kcollins@customink.com"]
  spec.description   = 'GIGO for ActiveRecord'
  spec.summary       = 'GIGO for ActiveRecord'
  spec.homepage      = 'http://github.com/customink/gigo-activerecord'
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency     'gigo'
  spec.add_runtime_dependency     'activerecord', '>= 3.0', '<= 5.0.0.1'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'pry'
end
