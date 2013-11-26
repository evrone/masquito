require 'resolv'
require 'pathname'

module Masquito
  class Settings
    def initialize(config_path)
      @pattern = File.join(config_path, '*')
    end

    def files
      Dir.glob(@pattern).select do |file|
        is_symlink = File.lstat(file).symlink?
        !is_symlink || (is_symlink && Pathname.new(file).exist?)
      end
    end

    def domains
      files.map do |symlink|
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
