require 'fileutils'
require 'test_helper'

require 'masquito'

class TestMasquitoSettings < Test::Unit::TestCase
  TEMP_DIR = File.join(Dir.pwd, 'test/tmp')

  attr_reader :settings

  def setup
    FileUtils.mkdir_p(TEMP_DIR)

    @settings = Masquito::Settings.new(TEMP_DIR)

    file = File.new(File.join(TEMP_DIR, 'file'), 'w')
    ['link', 'symlink.dev', 'symlink.domain'].each do |name|
      symlink = File.join(TEMP_DIR, name)
      FileUtils.ln_s(file.path, symlink)
    end
  end

  def teardown
    FileUtils.rm_rf(TEMP_DIR)
  end

  def test_symlinks
    result = ['link', 'symlink.dev', 'symlink.domain'].map do |name|
      File.join(TEMP_DIR, name)
    end

    assert_equal result, settings.symlinks
  end

  def test_domains
    result = ['link.dev.', 'symlink.dev.', 'symlink.domain.'].map do |name|
      Resolv::DNS::Name.create(name)
    end

    assert_equal result, settings.domains
  end

  def test_include
    assert settings.include?('link.dev.')
    assert settings.include?('sym.sym.link.dev.')
    assert settings.include?('symlink.dev.')
    assert settings.include?('www.symlink.dev.')
    assert settings.include?('symlink.domain.')
    assert settings.include?('asd.symlink.domain.')
  end
end
