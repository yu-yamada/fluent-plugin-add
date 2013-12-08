require 'pp'
class Fluent::AddOutput < Fluent::Output
  Fluent::Plugin.register_output('add', self)

  config_param :key, :string
  config_param :value, :string, :default => nil
  config_param :add_tag_prefix, :string, :default => 'greped'

  def initialize
    super
  end

  def configure(conf)
    super

    @key = @key.to_s
    @value = @value.to_s 
    @tag_prefix = "#{@add_tag_prefix}."
    @add_hash = Hash.new

    @tag_proc =
      if @tag_prefix
        Proc.new {|tag| "#{@tag_prefix}#{tag}" }
      else
        Proc.new {|tag| tag }
      end
    conf.elements.select {|element|
      element.name == 'pair' 
    }.each do |pair|
      pair.each do | k,v|
       @add_hash[k] = v
      end
    end 
  end

  def emit(tag, es, chain)
    emit_tag = @tag_proc.call(tag)

    es.each do |time,record|
      record[@key] = @value
      @add_hash.each do |k,v|
        record[k] = v
      end
      Fluent::Engine.emit(emit_tag, time, record)
    end

    chain.next
  end

end
