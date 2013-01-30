Gem::Specification.new do |gem|
  gem.authors       = ['Dmitry Vorotilin']
  gem.email         = ['d.vorotilin@gmail.com']
  gem.description   = 'Masquito is a dns masquerading server for rubists'
  gem.summary       = 'It masquerades your dns records'
  gem.homepage      = 'https://github.com/route/masquito'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'masquito'
  gem.require_paths = ['lib']
  gem.version       = '0.0.1'
end
