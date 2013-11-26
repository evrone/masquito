require 'erb'
require 'fileutils'
require 'tempfile'
require 'pathname'

module Masquito
  # When user installs Masquito we use his home path, but when it's launched as
  # daemon with superuser rights there's no home directory at all. That's why
  # we set environment variable and rely on it.
  CONFIG_PATH = ENV['CONFIG_PATH'] || File.join(ENV['HOME'], '.masquito')
  GEM_PATH    = File.expand_path('../../', __FILE__)
  BIN         = File.join(GEM_PATH, 'bin', 'masquito')

  autoload :Daemon,     'masquito/daemon'
  autoload :Settings,   'masquito/settings'
  autoload :Resolver,   'masquito/resolver'
  autoload :Installer,  'masquito/installer'
  autoload :VERSION,    'masquito/version'
end
