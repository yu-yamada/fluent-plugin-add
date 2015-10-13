require 'helper'

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

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::AddFilter, tag).configure(conf)
  end

  def test_configure
    d = create_driver
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
end
