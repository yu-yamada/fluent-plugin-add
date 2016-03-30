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
  CONFIG_UU = %[
    uuid true
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

    d = create_driver(CONFIG_UU)
    assert d.instance.config["uuid"] 
  end

  def test_format
    d = create_driver
    
    d.run do
      d.emit("a" => 1)
    end
    mapped = {'hoge' => 'moge', 'hogehoge' => 'mogemoge'}
    assert_equal [
      {"a" => 1}.merge(mapped),
    ], d.records

    d.run
  end
  def test_uu
    d = create_driver(CONFIG_UU)
    
    d.run do
      d.emit("a" => 1)
    end
    assert d.records[0].has_key?('uuid')

    d.run
  end
end
