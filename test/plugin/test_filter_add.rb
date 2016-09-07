require 'helper'
require 'fluent/test/driver/filter'

class AddFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
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
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::AddFilter).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG_UU)
    assert d.instance.config["uuid"]
  end

  def test_format
    d = create_driver

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.run(default_tag: 'test') do
      d.feed(time, "a" => 1)
    end
    mapped = {'hoge' => 'moge', 'hogehoge' => 'mogemoge'}
    expect = {"a" => 1}.merge(mapped)
    assert_equal [expect], d.filtered.map {|e| e.last }
  end
  def test_uu
    d = create_driver(CONFIG_UU)

    d.run(default_tag: 'test') do
      d.feed("a" => 1)
    end
    assert d.filtered.map {|e| e.last }.first.has_key?('uuid')
  end
  def test_uuid_key
    d = create_driver("#{CONFIG_UU}\nuuid_key test_uuid")

    d.run(default_tag: 'test') do
      d.feed("a" => 1)
    end
    assert d.filtered.map {|e| e.last }.first.has_key?('test_uuid')
  end
end
