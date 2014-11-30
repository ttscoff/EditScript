require "minitest/autorun"
require "editscript"

class TestEditScript < MiniTest::Unit::TestCase
  def test_parsed_options_returns_true_for_valid_arguments
    task = EditScript.search(["-v"], '')
    assert_equal task, ""
  end
end
