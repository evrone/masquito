require 'erb'
require 'fileutils'
require 'lunchy'
require 'tempfile'

module Masquito
  GEM_PATH = File.expand_path('../../../', __FILE__)
  TEMPLATE_PLIST_PATH = File.join(GEM_PATH, 'config', 'com.evrone.masquito.plist.erb')
  PLIST_NAME = File.basename(TEMPLATE_PLIST_PATH, '.erb')
  SERVICE_NAME = File.basename(PLIST_NAME, '.plist')

  RESOLVER_TEMPLATE_PATH = File.join(GEM_PATH, 'config', 'masquito.erb')
  RESOLVER_PATH = '/etc/resolver/masquito'

  module Install
    class << self
      def daemon_install
        abort_if_superuser
        FileUtils.mkdir_p(CONFIG_PATH)

        plist = ERB.new(File.read(TEMPLATE_PLIST_PATH))
        masquito_bin = File.join(GEM_PATH, 'bin', 'masquito')
        template = plist.result(binding)

        filename = File.join(Dir.tmpdir, PLIST_NAME)
        File.open(filename, 'w') { |f| f.write(template) }
        lunchy.install([filename])
        lunchy.start([SERVICE_NAME])
        File.unlink(filename)

        puts 'Daemon was successfully installed.'
        puts 'Run: sudo masquito resolver install'
      end

      def daemon_uninstall
        abort_if_superuser
        lunchy.stop([SERVICE_NAME])
        lunchy.uninstall([PLIST_NAME])
        puts "You can remove #{CONFIG_PATH} if you don't need these settings"
      end

      def resolver_install
        abort_unless_superuser
        resolver = ERB.new(File.read(RESOLVER_TEMPLATE_PATH))
        template = resolver.result(binding)
        File.open(RESOLVER_PATH, 'w') { |f| f.write(template) }
      end

      def resolver_uninstall
        abort_unless_superuser
        FileUtils.rm_rf(RESOLVER_PATH)
      end

      private

      def lunchy
        @lunchy ||= Lunchy.new
      end

      def abort_unless_superuser
        unless superuser?
          abort 'We need superuser privileges, run this command with sudo'
        end
      end

      def abort_if_superuser
        if superuser?
          abort 'No need superuser privileges, run this command without sudo'
        end
      end

      def superuser?
        [Process.uid, Process.euid] == [0, 0]
      end
    end
  end
end

class Lunchy
  CONFIG = { :verbose => false, :write => false }

  def uninstall(params)
    raise ArgumentError, "uninstall [file]" if params.empty?
    filename = params[0]
    %w(~/Library/LaunchAgents /Library/LaunchAgents).each do |dir|
      if File.exist?(File.expand_path(dir))
        FileUtils.rm_rf(File.join(File.expand_path(dir), File.basename(filename)))
        return puts "#{filename} uninstalled from #{dir}"
      end
    end
  end
end
