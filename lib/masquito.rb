module Masquito
  CONFIG_PATH = File.join(ENV['HOME'], '.masquito')

  autoload :DNS, 'masquito/dns'
  autoload :Settings, 'masquito/settings'
  autoload :VERSION, 'masquito/version'
end
