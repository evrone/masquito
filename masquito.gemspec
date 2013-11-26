lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'masquito/version'

Gem::Specification.new do |gem|
  gem.name          = 'masquito'
  gem.version       = Masquito::VERSION
  gem.authors       = ['Dmitry Vorotilin', 'Kir Shatrov']
  gem.email         = ['d.vorotilin@gmail.com', 'kirs@evrone.ru']
  gem.description   = 'Masquito is a DNS masquerading server for rubists and their applications'
  gem.summary       = 'Masquerades DNS records'
  gem.homepage      = 'https://github.com/evrone/masquito'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'lunchy'
  gem.add_runtime_dependency 'rb-fsevent'

  gem.add_development_dependency 'rake'
end
