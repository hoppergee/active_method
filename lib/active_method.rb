# frozen_string_literal: true

require_relative "active_method/version"

module ActiveMethod
  autoload :Util, "active_method/util"
  autoload :Executor, "active_method/executor"
  autoload :Base, "active_method/base"

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def active_method(name, method_class = nil, **options)
      method_class ||= Util.constantize self, Util.camel_case(name)

      if options[:class_method]
        define_singleton_method name do |*args, &block|
          method_class[self].call(*args, &block)
        end

      else
        define_method name do |*args, &block|
          method_class[self].call(*args, &block)
        end

        if options[:module_function]
          module_function name
        end
      end

    end
  end
end
