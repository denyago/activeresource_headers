# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeresource_headers/version'

Gem::Specification.new do |gem|
  gem.name          = "activeresource_headers"
  gem.version       = ActiveresourceHeaders::VERSION
  gem.authors       = ["Denis Yagofarov"]
  gem.email         = ["denyago@gmail.com"]
  gem.description   = %q{Send custom headers with ActiveResource requests}
  gem.summary       = %q{Adds custom_headers { ... } method to ActiveResource model. Those headers merged to deafult ones, each time AR requests api.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
