class Fluent::AddOutput < Fluent::Output
  Fluent::Plugin.register_output('add', self)

   # Define `router` method of v0.12 to support v0.10.57 or earlier
  unless method_defined?(:router)
    define_method("router") { Fluent::Engine }
  end

  config_param :add_tag_prefix, :string, :default => 'greped'

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
       @add_hash[k] = v
      end
    end 
  end

  def emit(tag, es, chain)
    emit_tag = @tag_proc.call(tag)

    es.each do |time,record|
      @add_hash.each do |k,v|
        record[k] = v
      end
      router.emit(emit_tag, time, record)
    end

    chain.next
  end

end
