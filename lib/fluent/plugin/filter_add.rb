require 'securerandom'
require 'fluent/plugin/filter'

class Fluent::Plugin::AddFilter < Fluent::Plugin::Filter
  Fluent::Plugin.register_filter('add', self)

  config_param :uuid, :bool, :default => false
  config_param :uuid_key, :string, :default => 'uuid'

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
       pair.has_key?(k)  # suppress warnings about unused configuration
       @add_hash[k] = v
      end
    end
  end

  def filter(tag, time, record)
    @add_hash.each do |k,v|
      record[k] = v
    end
    if @uuid
      record[@uuid_key] = SecureRandom.uuid.upcase
    end
    record
  end
end
