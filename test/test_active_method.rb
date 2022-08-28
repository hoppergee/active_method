# frozen_string_literal: true

require "test_helper"

class TestActiveMethod < ApplicationTest 

  def test_that_it_has_a_version_number
    refute_nil ::ActiveMethod::VERSION
  end

end
