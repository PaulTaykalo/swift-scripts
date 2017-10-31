require 'minitest/autorun'
require 'swift-unused'

class SwiftUnusedTest < Minitest::Test
  def setup
    @unused = create_sut
    @unused.search
  end  

  def test_initial_state
    assert(!@unused.nil?, "Should be able to create instance of unused")
  end

  def test_unused_classes
    assert_includes(@unused.classes, 'A')    
    assert_includes(@unused.classes, 'B')    
  end

  def test_used_classes_by_inheritance
    assert_includes(@unused.classes, 'D')    
    refute_includes(@unused.classes, 'C')    
  end

  def test_unused_protocols
    assert_includes(@unused.protocols, 'E')    
  end  

  def test_used_protocols_by_inheritance
    assert_includes(@unused.protocols, 'G')    
    refute_includes(@unused.protocols, 'F')    
  end

  def create_sut
    SwiftUnused.new("./test/fixtures/Unused.ast")
  end  

end
