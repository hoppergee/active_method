# frozen_string_literal: true

require_relative "active_method/version"

module ActiveMethod
  autoload :Base, "active_method/base"
  autoload :Util, "active_method/util"

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def active_method(name, method_class = nil)
      method_class ||= Util.constantize self, Util.camel_case(name)

      define_method name do |*args|
        method = method_class.new(*args)
        method.__set_owner(self)
        method.call
      end
    end
  end
end
