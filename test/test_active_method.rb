# frozen_string_literal: true

require "test_helper"

class TestActiveMethod < ApplicationTest 

  def test_that_it_has_a_version_number
    refute_nil ::ActiveMethod::VERSION
  end

  ################
  # .active_method
  ################

  class Buzz < ActiveMethod::Base
    argument :a
    argument :b
    keyword_argument :c
    keyword_argument :d

    def call
      [a, b, c, d, foo_bar.x, foo_bar.y, foo_bar.z]
    end
  end

  class BAZ < ActiveMethod::Base
    argument :a
    argument :b
    keyword_argument :c
    keyword_argument :d

    def call
      [a, b, c, d, foo_bar.x, foo_bar.y, foo_bar.z]
    end
  end

  module Example
    class FooBar
      include ActiveMethod

      active_method :buzz
      active_method :baz, BAZ

      def x; 'x'; end
      def y; 'y'; end
      def z; 'z'; end
    end
  end

  it ".active_method - infer method class base on name" do
    assert_equal ['a', 'b', 'c', 'd', 'x', 'y', 'z'], Example::FooBar.new.buzz('a', 'b', c: 'c', d: 'd')
  end

  it ".active_method - direct set method class" do
    assert_equal ['a', 'b', 'c', 'd', 'x', 'y', 'z'], Example::FooBar.new.baz('a', 'b', c: 'c', d: 'd')
  end

  ################
  # .active_method for module
  ################

  class Hi < ActiveMethod::Base
    argument :name

    def call
      "Hi, #{name}"
    end
  end

  class Bye < ActiveMethod::Base
    argument :name

    def call
      "Bye, #{name}"
    end
  end

  module Say
    include ActiveMethod

    active_method :hi
    active_method :bye, module_function: true
  end

  class Person
    include Say
  end

  class Dog
    include ActiveMethod
  end

  it ".acive_method - works on module" do
    assert_equal "Hi, John", Person.new.hi("John")
  end

  it ".acive_method - works as a module_function" do
    assert_equal "Bye, John", Say.bye("John")
  end

  it ".acive_method - raise error for a class when pass module_functin: true" do
    error = assert_raises NoMethodError do
      Dog.active_method(:hi, module_function: true)
    end
    assert_includes error.message, "undefined method `module_function'"
  end

end
