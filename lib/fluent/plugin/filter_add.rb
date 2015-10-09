class Fluent::AddFilter < Fluent::Filter
  Fluent::Plugin.register_filter('add', self)

  def initialize
    super
  end

  def configure(conf)
    super

    @add_hash = Hash.new

    conf.elements.select {|element|
      element.name == 'pair'
    }.each do |pair|
      pair.each do | k,v|
       @add_hash[k] = v
      end
    end
  end

  def filter(tag, time, record)
    @add_hash.each do |k,v|
      record[k] = v
    end
    record
  end
end
