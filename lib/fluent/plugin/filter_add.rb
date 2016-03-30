require 'securerandom'

class Fluent::AddFilter < Fluent::Filter
  Fluent::Plugin.register_filter('add', self)

  config_param :uuid, :bool, :default => false
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
    if @uuid
      record['uuid'] = SecureRandom.uuid.upcase
    end
    record
  end
end if defined?(Fluent::Filter)
