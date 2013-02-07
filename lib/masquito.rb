module Masquito
  MASQUITO_ROOT = File.expand_path("../../", __FILE__)
  USER_CONFIG_DIR = File.join(ENV['HOME'], '.masquito')

  autoload :DNS, 'masquito/dns'
  autoload :Settings, 'masquito/settings'

  class << self
    def bin_path
      "#{MASQUITO_ROOT}/bin/masquito"
    end

    def start
      while true
        puts "started"
        sleep 1
      end
    end

    def debug(message)
      STDERR.puts message
    end
  end
end
