require 'erb'

module Masquito
  class Launchctl
    PLIST_DIR = File.join(ENV["HOME"], "Library/LaunchAgents")
    SERVICE_NAME_TEMPLATE = "com.evrone.masquito"
    PLIST = File.join(PLIST_DIR, "#{SERVICE_NAME_TEMPLATE}.plist")
    PLIST_TEMPLATE = File.join(MASQUITO_ROOT, "config", "#{SERVICE_NAME_TEMPLATE}.plist.erb")

    class << self
      def install
        mkdir_plist

        create_plist
        load_plist(self::PLIST)
      end

      def uninstall
        stop_plist(self::SERVICE_NAME_TEMPLATE)
        unload_plist(self::PLIST)
        remove_plist
      end

      private

      def create_plist
        config = ERB.new File.read(self::PLIST_TEMPLATE)
        Masquito.debug "Open plist template #{self::PLIST_TEMPLATE}"
        template = config.result(binding)

        Masquito.debug "Write plist #{self::PLIST}"
        File.open(self::PLIST, "w") do |file|
          file.write template
        end
      end

      def remove_plist
        if File.exist?(self::PLIST)
          Masquito.debug "Remove plist #{self::PLIST}"
          FileUtils.rm(self::PLIST)
        end
      end

      def mkdir_plist
        FileUtils.mkdir_p(self::PLIST_DIR) unless File.exist?(self::PLIST_DIR)
      end

      # Load configuration files
      def load_plist(plist)
        Masquito.debug "Loading plist #{plist}"
        invoke("launchctl", "load", "-w", plist)
      end

      # Unload configuration files
      def unload_plist(plist)
        Masquito.debug "Unloading plist #{plist}"
        invoke("launchctl", "unload", "-w", plist)
      end

      # Stop specified job
      def stop_plist(name)
        invoke("launchctl", "stop", name)
      end

      def invoke(*args)
        system(*args)
      end

      def ruby_path
        `which ruby`.delete("\n")
      end
    end
  end
end
