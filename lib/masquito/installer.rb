require 'lunchy'

# Lunchy doesn't have uninstall method and also installs all plists to
# LaunchAgents. We can send a PR on spare time.
class Lunchy
  CONFIG = { :verbose => false, :write => nil }

  def install(params)
    raise ArgumentError, "install [file]" if params.empty?
    filename = params[0]
    %w(/Library/LaunchDaemons).each do |dir|
      if File.exist?(File.expand_path(dir))
        FileUtils.cp filename, File.join(File.expand_path(dir), File.basename(filename))
        return puts "#{filename} installed to #{dir}"
      end
    end
  end

  def uninstall(params)
    raise ArgumentError, "uninstall [file]" if params.empty?
    filename = params[0]
    %w(/Library/LaunchDaemons).each do |dir|
      if File.exist?(File.expand_path(dir))
        FileUtils.rm_rf(File.join(File.expand_path(dir), File.basename(filename)))
        return puts "#{filename} removed from #{dir}"
      end
    end
  end
end

module Masquito
  class Installer
    SERVICE_NAME = 'com.evrone.masquito'
    SERVICE_PLIST = "#{SERVICE_NAME}.plist"
    SERVICE_TEMPLATE_PATH = File.join(GEM_PATH, 'config', "#{SERVICE_PLIST}.erb")

    def initialize
      @lunchy = Lunchy.new
    end

    def install
      switch_privileges {
        FileUtils.mkdir_p(CONFIG_PATH)
      }

      plist = ERB.new File.read(SERVICE_TEMPLATE_PATH)
      template = plist.result(binding)

      filename = File.join(Dir.tmpdir, SERVICE_PLIST)
      File.open(filename, 'w') { |f| f.write(template) }
      @lunchy.install([filename])
      @lunchy.start([SERVICE_NAME])
      File.unlink(filename)

      puts "Daemon was successfully installed."
    end

    def remove
      @lunchy.stop([SERVICE_NAME])
      @lunchy.uninstall([SERVICE_PLIST])
      puts "You can remove #{CONFIG_PATH} if you don't need these settings"
    end

    private

    def switch_privileges(&block)
      uid, Process.uid = Process.uid, ENV['SUDO_UID'].to_i
      Process::UID.switch(&block)
    ensure
      Process.uid = uid
    end
  end
end
