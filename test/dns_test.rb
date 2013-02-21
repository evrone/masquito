require 'resolv'
require 'fileutils'
require 'test_helper'

require 'masquito'

class TestMasquitoDNS < Test::Unit::TestCase
  TEMP_DIR = File.join(Dir.pwd, 'test/tmp')

  def setup
    FileUtils.mkdir_p(TEMP_DIR)

    file = File.new(File.join(TEMP_DIR, 'file'), 'w')
    ['link', 'symlink.dev', 'symlink.domain'].each do |name|
      symlink = File.join(TEMP_DIR, name)
      FileUtils.ln_s(file.path, symlink)
    end

    @thread = Thread.new do
      Masquito::DNS.new('127.0.0.1', '53532', TEMP_DIR)
    end
  end

  def teardown
    @thread.kill

    FileUtils.rm_rf(TEMP_DIR)
  end

  def test_responses
    silence_warnings do
      Resolv::DNS.const_set(:Port, 53532)
    end

    response = Resolv::IPv4.create('127.0.0.1')
    Resolv::DNS.open(:nameserver => ['127.0.0.1']) do |dns|
      assert_equal response, dns.getaddress('link.dev.')
      assert_equal response, dns.getaddress('sym.sym.link.dev.')
      assert_equal response, dns.getaddress('symlink.dev.')
      assert_equal response, dns.getaddress('www.symlink.dev.')
      assert_equal response, dns.getaddress('symlink.domain.')
      assert_equal response, dns.getaddress('asd.symlink.domain.')
    end
  end
end
