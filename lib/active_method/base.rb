module ActiveMethod
  class Base

    class Argument
      attr_reader :name, :default

      def initialize(name, default: nil)
        @name = name
        @default = default
      end
    end

    class << self

      def call(*args)
        new(*args).call
      end

      def arguments
        class_variable_get(:@@arguments)
      end

      def keyword_arguments
        class_variable_get(:@@keyword_arguments)
      end

      private

      def method_missing(method_name, *args)
        case method_name.to_s
        when /^argument(_\d)*$/
          init_arguments
          parse_argument(method_name, *args)
        when 'keyword_argument'
          init_keyword_arguments
          parse_keyword_argument(*args)
        else
          super
        end
      end

      def parse_argument(method_name, name, opts = {})
        _, index = method_name.to_s.split('_')
        if index.nil?
          index = (arguments.keys.max || 0) + 1
        end
        arguments[Integer(index)] = Argument.new(name, **opts)

        define_method name do
          instance_variable_get("@#{name}")
        end
      end

      def parse_keyword_argument(name, opts = {})
        keyword_arguments << Argument.new(name, **opts)

        define_method name do
          instance_variable_get("@#{name}")
        end
      end

      def init_arguments
        return if self.class_variable_defined?(:@@arguments)

        self.class_variable_set(:@@arguments, {})
      end

      def init_keyword_arguments
        return if self.class_variable_defined?(:@@keyword_arguments)

        self.class_variable_set(:@@keyword_arguments, [])
      end
    end

    def initialize(*args)
      arguments.each do |index, argument|
        begin
          instance_variable_set("@#{argument.name}", args.fetch(index - 1))
        rescue IndexError
          instance_variable_set("@#{argument.name}", argument.default)
        end
      end

      opts = args[arguments.count] || {}
      keyword_arguments.each do |argument|
        if opts.key?(argument.name.to_sym)
          instance_variable_set("@#{argument.name}", opts[argument.name.to_sym])
        elsif opts.key?(argument.name.to_s)
          instance_variable_set("@#{argument.name}", opts[argument.name.to_s])
        else
          instance_variable_set("@#{argument.name}", argument.default)
        end
      end
    end

    def call
    end

    private

    def arguments
      self.class.arguments
    end

    def keyword_arguments
      self.class.keyword_arguments
    end

  end
end