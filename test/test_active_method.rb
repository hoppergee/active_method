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

end
