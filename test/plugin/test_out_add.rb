require 'helper'
require 'fluent/test/driver/output'

class AddOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    add_tag_prefix pre_hoge
    <pair>
      hoge moge
      hogehoge mogemoge
    </pair>
  ]
  CONFIG_UU = %[
    uuid true
    <pair>
      hoge moge
      hogehoge mogemoge
    </pair>
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::AddOutput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal 'pre_hoge', d.instance.config["add_tag_prefix"]

    d = create_driver(CONFIG_UU)
    assert d.instance.config["uuid"]
  end

  def test_format
    d = create_driver

    d.run(default_tag: 'test') do
      d.feed("a" => 1)
    end
    mapped = {'hoge' => 'moge', 'hogehoge' => 'mogemoge'}
    assert_equal [
      {"a" => 1}.merge(mapped),
    ], d.events.map {|e| e.last }
  end
  def test_uu
    d = create_driver(CONFIG_UU)

    d.run(default_tag: 'test') do
      d.feed("a" => 1)
    end
    assert d.events.map{|e| e.last }.first.has_key?('uuid')
  end
  def test_uuid_key
    d = create_driver("#{CONFIG_UU}\nuuid_key test_uuid")

    d.run(default_tag: 'test') do
      d.feed("a" => 1)
    end
    assert d.events.map{|e| e.last}.first.has_key?('test_uuid')
  end
end
