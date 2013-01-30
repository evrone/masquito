require 'resolv'
require 'pathname'

module Masquito
  class Settings
    def initialize(config_path)
      @pattern = File.join(config_path, '*')
    end

    def symlinks
      Dir.glob(@pattern).select do |file|
        File.lstat(file).symlink? && Pathname.new(file).exist?
      end
    end

    def domains
      symlinks.map do |symlink|
        name = File.basename(symlink)
        Resolv::DNS::Name.create(has_domain?(name) ? "#{name}." : "#{name}.dev.")
      end
    end

    def include?(name)
      name = Resolv::DNS::Name.create(name) if name.kind_of?(String)
      domains.any? { |n| name.eql?(n) || name.subdomain_of?(n) }
    end

    private

    def has_domain?(name)
      name.split('.').length >= 2
    end
  end
end
