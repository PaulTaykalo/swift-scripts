require 'minitest/autorun'
require 'swift-unused'

class SwiftUnusedTest < Minitest::Test
  def setup
    @unused = create_sut
  end  

  def test_initial_state
    assert(!@unused.nil?, "Should be able to create instance of unused")
  end

  def test_unused_classes
    assert_includes(@unused.classes, 'A')    
    assert_includes(@unused.classes, 'B')    
  end

  def create_sut
    SwiftUnused.new("./test/fixtures/Unused.ast")
  end  

end
