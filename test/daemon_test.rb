require 'resolv'
require 'fileutils'
require 'test_helper'

require 'masquito'

class TestMasquitoDaemon < Test::Unit::TestCase
  TEMP_DIR = File.join(Dir.pwd, 'test/tmp')

  def setup
    FileUtils.mkdir_p(TEMP_DIR)

    file = File.new(File.join(TEMP_DIR, 'file'), 'w')
    ['symlink.dev', 'symlink.domain'].each do |name|
      symlink = File.join(TEMP_DIR, name)
      FileUtils.ln_s(file.path, symlink)
    end

    @thread = Thread.new do
      Masquito::Daemon.new(TEMP_DIR, '127.0.0.1', '51234').start_dns_server
    end
  end

  def teardown
    @thread.kill

    FileUtils.rm_rf(TEMP_DIR)
  end

  def test_responses
    silence_warnings do
      Resolv::DNS.const_set(:Port, 51234)
    end

    response = Resolv::IPv4.create('127.0.0.1')
    Resolv::DNS.open(:nameserver => ['127.0.0.1']) do |dns|
      assert_equal response, dns.getaddress('symlink.dev.')
      assert_equal response, dns.getaddress('www.symlink.dev.')
      assert_equal response, dns.getaddress('symlink.domain.')
      assert_equal response, dns.getaddress('asd.symlink.domain.')
    end
  end
end
