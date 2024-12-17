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

  ################
  # .active_method for class method
  ################

  class BuildARobot < ActiveMethod::Base
    argument :name

    def call
      "#{robot_factory} build a robot called #{name}"
    end
  end

  class RobotFactory
    include ActiveMethod

    active_method :build_a_robot, class_method: true
  end

  it ".acive_method - works as a class method" do
    assert_equal "TestActiveMethod::RobotFactory build a robot called B-2", RobotFactory.build_a_robot("B-2")
  end

  it ".acive_method - won't works as a instance method" do
    error = assert_raises NoMethodError do
      RobotFactory.new.build_a_robot("B-2")
    end
    assert_includes error.message, "undefined method `build_a_robot'"
  end

  ################
  # .active_method with &block
  ################

  class SetInstanceConfig < ActiveMethod::Base

    def call
      yield instance_configuration
    end

  end

  class InstanceConfiguration
    include ActiveMethod

    attr_accessor :a
    attr_accessor :b

    active_method :config, SetInstanceConfig
  end

  it ".active_method work as a instance method with a block" do
    configuration = InstanceConfiguration.new
    configuration.config do |config|
      config.a = 'aaa'
      config.b = 'bbb'
    end
    assert_equal 'aaa', configuration.a
    assert_equal 'bbb', configuration.b
  end

  class SetModuleConfig < ActiveMethod::Base

    def call
      yield @__method_owner
    end

  end

  module ModuleConfiguration
    include ActiveMethod

    module_function

    def a
      @a
    end

    def a=(value)
      @a = value
    end

    active_method :config, SetModuleConfig, module_function: true
  end

  it ".active_method work as a module method with a block" do
    ModuleConfiguration.config do |config|
      config.a = 'aaa'
    end
    assert_equal 'aaa', ModuleConfiguration.a
  end

  class SetClassConfig < ActiveMethod::Base

    def call
      yield class_configuration
    end

  end

  class ClassConfiguration
    include ActiveMethod

    class << self
      def a
        @@a
      end

      def a=(value)
        @@a = value
      end
    end

    active_method :config, SetClassConfig, class_method: true
  end

  it ".active_method work as a instance method with a block" do
    ClassConfiguration.config do |config|
      config.a = 'aaa'
    end
    assert_equal 'aaa', ClassConfiguration.a
  end

  ################
  # .active_method customize owner name
  ################

  class PowerOff < ActiveMethod::Base
    owner :machine

    def call
      machine.off = true
    end
  end

  class Desktop
    include ActiveMethod
    active_method :power_off
    attr_accessor :off
  end

  class Laptop
    include ActiveMethod
    active_method :power_off
    attr_accessor :off
  end

  it ".active_method can customize owenr name for sharing to work like a concern" do
    desktop = Desktop.new
    desktop.power_off
    assert desktop.off

    laptop = Laptop.new
    laptop.power_off
    assert laptop.off
  end

  ################
  # .active_method with inheritance 
  ################

  class DemoAPIBase < ActiveMethod::Base
    owner :client
  end

  class GetA < DemoAPIBase
    argument :id

    def call
      puts "Request GET: /a"
    end
  end

  class GetB < DemoAPIBase
    keyword_argument :first
    keyword_argument :per

    def call
      puts "Request GET: /b"
    end
  end

  class Client
    include ActiveMethod
    active_method :get_a
    active_method :get_b
  end

  it ".active_method can orgianize with a Base methd" do
    get_a_arguments = GetA.arguments.values
    assert_equal 1, get_a_arguments.count
    assert_equal :id, get_a_arguments[0].name
    get_a_keyword_arguments = GetA.keyword_arguments
    assert_equal 0, get_a_keyword_arguments.count
    assert_equal :client, GetA.owner_name

    get_b_arguments = GetB.arguments.values
    assert_equal 0, get_b_arguments.count
    get_b_keyword_arguments = GetB.keyword_arguments
    assert_equal :first, get_b_keyword_arguments[0].name
    assert_equal :per, get_b_keyword_arguments[1].name
    assert_equal :client, GetB.owner_name
  end

end
