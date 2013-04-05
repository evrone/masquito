lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masquito/version'

Gem::Specification.new do |gem|
  gem.name          = 'masquito'
  gem.version       = Masquito::VERSION
  gem.authors       = ['Dmitry Vorotilin', 'Kir Shatrov']
  gem.email         = ['d.vorotilin@gmail.com', 'kirs@evrone.ru']
  gem.description   = 'Masquito is a dns masquerading server for rubists'
  gem.summary       = 'It masquerades your dns records'
  gem.homepage      = 'https://github.com/evrone/masquito'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'lunchy'
end
