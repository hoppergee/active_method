# frozen_string_literal: true

require "test_helper"

class ActiveMethod::TestBase < ApplicationTest

  it ".call" do
    klass :ExampleMethod, ActiveMethod::Base do
      argument :a
      argument :b, default: 2
      keyword_argument :c
      keyword_argument :d, default: 4

      def call
        [a, b, c, d]
      end
    end

    assert_equal [1, 2, nil, 4], ExampleMethod.call(1)
    assert_equal [1, 3, nil, 4], ExampleMethod.call(1, 3)
    assert_equal [1, 3, 6, 4],   ExampleMethod.call(1, 3, c: 6)
    assert_equal [1, 3, 4, 5],   ExampleMethod.call(1, 3, c: 4, d: 5)

    remove_klass :ExampleMethod
  end

  it ".call - with argument_(number)" do
    klass :ExampleMethod, ActiveMethod::Base do
      argument_2 :b, default: 2
      argument_1 :a
      keyword_argument :d, default: 4
      keyword_argument :c

      def call
        [a, b, c, d]
      end
    end

    assert_equal [1, 2, nil, 4], ExampleMethod.call(1)
    assert_equal [1, 3, nil, 4], ExampleMethod.call(1, 3)
    assert_equal [1, 3, 6, 4],   ExampleMethod.call(1, 3, c: 6)
    assert_equal [1, 3, 4, 5],   ExampleMethod.call(1, 3, c: 4, d: 5)

    remove_klass :ExampleMethod
  end

  it ".call - with single argument" do
    klass :ExampleMethod, ActiveMethod::Base do
      argument :a

      def call
        a
      end
    end

    assert_equal 1, ExampleMethod.call(1)
    assert_equal 2, ExampleMethod.call(2)

    remove_klass :ExampleMethod
  end

  it ".call - with two arguments" do
    klass :ExampleMethod, ActiveMethod::Base do
      argument :a
      argument :b, default: 2

      def call
        [a, b]
      end
    end

    assert_equal [1, 2], ExampleMethod.call(1)
    assert_equal [1, 3], ExampleMethod.call(1, 3)

    remove_klass :ExampleMethod
  end

  it ".call - with one keyword argument" do
    klass :ExampleMethod, ActiveMethod::Base do
      keyword_argument :a

      def call
        a
      end
    end

    assert_equal 1, ExampleMethod.call(a: 1)
    assert_equal 3, ExampleMethod.call(a: 3)

    remove_klass :ExampleMethod
  end

  it ".call - with two keyword arguments" do
    klass :ExampleMethod, ActiveMethod::Base do
      keyword_argument :a
      keyword_argument :b, default: 2

      def call
        [a, b]
      end
    end

    assert_equal [1, 2], ExampleMethod.call(a: 1)
    assert_equal [1, 3], ExampleMethod.call(a: 1, b: 3)

    remove_klass :ExampleMethod
  end

end
