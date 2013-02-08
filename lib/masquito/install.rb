require 'fileutils'
require "masquito/install/launchctl"

module Masquito
  class << self
    def mac?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    def install
      check_if_mac!

      mkdir_user_config
      install_launchctl
    end

    def uninstall
      check_if_mac!

      rmdir_user_config
      uninstall_launchctl
    end

    private

    def check_if_mac!
      abort("Currently only macs sorry.") unless mac?
    end

    def install_launchctl
      Launchctl.install
    end

    def uninstall_launchctl
      Launchctl.uninstall
    end

    def mkdir_user_config
      FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
    end

    def rmdir_user_config
      FileUtils.rm_rf(USER_CONFIG_DIR) if File.directory?(USER_CONFIG_DIR)
    end
  end
end
