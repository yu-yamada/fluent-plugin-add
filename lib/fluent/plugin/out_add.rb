require 'securerandom'
require 'fluent/plugin/output'

class Fluent::Plugin::AddOutput < Fluent::Plugin::Output
  Fluent::Plugin.register_output('add', self)

  helpers :event_emitter

   # Define `router` method of v0.12 to support v0.10.57 or earlier
  unless method_defined?(:router)
    define_method("router") { Fluent::Engine }
  end

  config_param :add_tag_prefix, :string, :default => 'greped'
  config_param :uuid, :bool, :default => false
  config_param :uuid_key, :string, :default => 'uuid'

  def initialize
    super
  end

  def configure(conf)
    super

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
       pair.has_key?(k) # suppress warnings about unused configuration
       @add_hash[k] = v
      end
    end
  end

  def process(tag, es)
    emit_tag = @tag_proc.call(tag)

    es.each do |time,record|
      @add_hash.each do |k,v|
        record[k] = v
      end
      if @uuid
        record[@uuid_key] = SecureRandom.uuid.upcase
      end
      router.emit(emit_tag, time, record)
    end
  end

end
