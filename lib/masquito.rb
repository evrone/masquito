module Masquito
  CONFIG_PATH = File.join(ENV['HOME'], '.masquito')

  autoload :DNS,      'masquito/dns'
  autoload :Settings, 'masquito/settings'
  autoload :Install,  'masquito/install'
  autoload :VERSION,  'masquito/version'
end
