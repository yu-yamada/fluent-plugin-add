require 'helper'

class AddFilterTest < Test::Unit::TestCase
  def setup
    omit("Use Fluentd v0.12 or later.") unless defined?(Fluent::Filter)

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

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::AddFilter, tag).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG_UU)
    assert d.instance.config["uuid"]
  end

  def test_format
    d = create_driver

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.run do
      d.filter("a" => 1)
    end
    mapped = {'hoge' => 'moge', 'hogehoge' => 'mogemoge'}
    expect = {"a" => 1}.merge(mapped)
    assert_equal expect, d.filtered_as_array[0][2]
  end
  def test_uu
    d = create_driver(CONFIG_UU)

    d.run do
      d.emit("a" => 1)
    end
    assert d.filtered_as_array[0][2].has_key?('uuid')

    d.run
  end
  def test_uuid_key
    d = create_driver("#{CONFIG_UU}\nuuid_key test_uuid")

    d.run do
      d.emit("a" => 1)
    end
    assert d.filtered_as_array[0][2].has_key?('test_uuid')

    d.run
  end
end
