module Procmon
  class ProcessFactory
    attr_reader :attributes, :name, :checks
    def initialize(name, attributes, process_block)
      @checks = {}
      @name = name
      @attributes = attributes
      if process_block.arity == 0
        instance_eval &process_block
      else
        instance_exec(self, &process_block)
      end
    end

    def method_missing(name, *args)
      if args.size == 1 && name.to_s =~ /^(.*)=$/
        @attributes[$1.to_sym] = args.first
      elsif args.size == 1
        @attributes[name.to_sym] = args.first
      elsif args.size == 0 && name.to_s =~ /^(.*)!$/
        @attributes[$1.to_sym] = true
      elsif args.empty? && @attributes.key?(name.to_sym)
        @attributes[name.to_sym]
      else
        super
      end
    end

    def checks(name, options = {}, &block)
      if block
        options[:actions] ||= []
        options[:actions] << block
      end
      @checks[name] = options
    end

    def create_process
      Process.new(@name, @checks, @attributes)
    end    
  end
end
