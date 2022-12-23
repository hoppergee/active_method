module ActiveMethod
  class Executor

    attr_reader :method_class, :owner

    def initialize(klass, owner)
      @method_class = klass
      @owner = owner
    end

    def call(*args, &block)
      method = method_class.new(*args)
      method.__set_owner(owner)
      method.call(&block)
    end

  end
end