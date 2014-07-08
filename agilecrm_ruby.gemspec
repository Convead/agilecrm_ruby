# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agilecrm/version'

Gem::Specification.new do |spec|
  spec.name          = 'agilecrm_ruby'
  spec.version       = AgileCRM::VERSION
  spec.authors       = ['Babur Usenakunov']
  spec.email         = ['bob.usenakunov@gmail.com']
  spec.description   = %q{A Ruby interface to the Agile CRM API}
  spec.summary       = %q{A Ruby interface to the Agile CRM API}
  spec.homepage      = 'https://github.com/Convead/agilecrm_ruby'
  spec.license       = 'MIT'

  spec.files = %w[LICENSE.txt README.md Rakefile agilecrm_ruby.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 0.7.4'
  spec.add_dependency 'faraday_middleware', '>= 0.8.0'

  spec.add_development_dependency 'bundler', '~> 1.0'
end
