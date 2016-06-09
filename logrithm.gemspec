# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logrithm/version'

Gem::Specification.new do |spec|
  spec.name          = 'logrithm'
  spec.version       = Logrithm::VERSION
  spec.authors       = ['Aleksei Matiushkin']
  spec.email         = ['aleksei.matiushkin@kantox.com']

  spec.summary       = %q{Standard logger improvements}
  spec.description   = %q{Some improvements to standard logger, such as detailed colored logger messages etc.}
  spec.homepage      = 'https://kantox.com'
  spec.license       = 'MIT'

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
end
