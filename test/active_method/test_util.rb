# frozen_string_literal: true

require "test_helper"

class TestUtil < ApplicationTest

  it "constantize - raise error on missing constant" do
    error = assert_raises NameError do
      ActiveMethod::Util.constantize(Object, 'WrongName')
    end

    assert_includes error.message, "wrong constant name WrongName"
  end

end
