require 'helper'

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
  
  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::AddOutput, tag).configure(conf)
  end

  def test_configure 
    d = create_driver
    assert_equal 'pre_hoge', d.instance.config["add_tag_prefix"] 
  end

  def test_format
    d = create_driver
    
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.run do
      d.emit("a" => 1)
    end
    mapped = {'hoge' => 'moge', 'hogehoge' => 'mogemoge'}
    assert_equal [
      {"a" => 1}.merge(mapped),
    ], d.records

    d.run
  end
end
