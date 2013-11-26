require 'rb-fsevent'

module Masquito
  class Resolver
    RESOLVER_TEMPLATE_PATH = File.join(GEM_PATH, 'config', 'masquito.erb')
    RESOLVERS_PATH = Pathname.new('/etc/resolver')

    def initialize(config_path)
      @config_path = config_path
    end

    def start
      reset
      fsevent = FSEvent.new
      fsevent.watch(@config_path) { reset }
      fsevent.run
    end

    def reset
      remove_configs
      copy_configs
    end

    def copy_configs
      resolver = ERB.new File.read(RESOLVER_TEMPLATE_PATH)
      template = resolver.result(binding)
      Masquito::Settings.new(CONFIG_PATH).domains.each do |domain|
        File.open(RESOLVERS_PATH.join(domain.to_s), 'w') { |f| f.write(template) }
      end
    end

    def remove_configs
      Dir.foreach(RESOLVERS_PATH) do |name|
        next if name == '.' or name == '..'
        path = RESOLVERS_PATH.join(name)
        if File.new(path).readline == %Q(# Masquito magic comment\n)
          FileUtils.rm_rf(path)
        end
      end
    end
  end
end
