module ActiveMethod
  module Util
    module_function

    def constantize(klass, name)
      constant = klass.const_get(name) rescue nil
      return constant unless constant.nil?

      namespaces_of(klass).each do |namespace|
        constant = namespace.const_get(name) rescue nil
        return constant unless constant.nil?
      end

      raise NameError.new("wrong constant name #{name}") if constant.nil?
    end

    def namespaces_of(klass)
      namespaces = []

      names = klass.name.split("::")
      names.pop
      while !names.empty?
        namespaces << Object.const_get(names.join("::"))
        names.pop
      end

      namespaces
    end

    def camel_case(str)
      str = str.to_s
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split("_").map(&:capitalize).join
    end

    def snake_case(str)
      return str.downcase if str =~ /^[A-Z_]+$/
      str.gsub(/\B[A-Z]/, '_\&').squeeze("_") =~ /_*(.*)/
      $+.downcase
    end

  end
end