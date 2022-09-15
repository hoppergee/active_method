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
    def active_method(name, method_class = nil)
      method_class ||= Util.constantize self, Util.camel_case(name)

      define_method name do |*args|
        method_class[self].call(*args)
      end
    end
  end
end
