require 'minitest/autorun'
require 'swift-unused'

class SwiftUnusedTest < Minitest::Test
  def test_unused_classes
    with_swift_ast "0000", """
    class A {}
    class B {}
    """ #, skip_cache=true
    assert_includes(@unused.classes, 'A')    
    assert_includes(@unused.classes, 'B')    
  end

  def test_used_classes_by_inheritance
    with_swift_ast "0001", """
    class C {} // used by inheritance
    class D: C {} // unused
    """ #, skip_cache=true
    assert_includes(@unused.classes, 'D')    
    refute_includes(@unused.classes, 'C')    
  end

  def test_unused_protocols
    with_swift_ast "0002", """
    protocol E {} // unused
    protocol F {} // unused
    """ #, skip_cache=true
    assert_includes(@unused.protocols, 'E')    
    assert_includes(@unused.protocols, 'F')    
  end  

  def test_used_protocols_by_inheritance
    with_swift_ast "0003", """
    protocol F {}
    protocol G: F {} 

    protocol H {} 
    class I: H {}

    protocol J {}
    struct K: J {}  
    """ #, skip_cache=true
    assert_includes(@unused.protocols, 'G')    
    refute_includes(@unused.protocols, 'F')    
    refute_includes(@unused.protocols, 'H')    
    refute_includes(@unused.protocols, 'J')    

  end

  def test_used_protocol_by_extension
    with_swift_ast "0004", """
    class C {}        // unused
    protocol F {}     // used by extension
    extension C: F {}
    """ #, skip_cache=true
    refute_includes(@unused.protocols, 'F')        
    assert_includes(@unused.classes, 'C')    
    
  end

  def test_unused_structs
    with_swift_ast "0005", """
    struct A {} // unused
    struct B {} // unused
    """#, skip_cache=true
    assert_includes(@unused.structs, 'A')    
    assert_includes(@unused.structs, 'B')    

  end

  def test_unused_enums
    with_swift_ast "0006", """
    enum A {} // unused
    enum B {} // unused
    """#, skip_cache=true
    assert_includes(@unused.enums, 'A')    
    assert_includes(@unused.enums, 'B')    
  end

  def test_used_items_in_lets_and_vars
    with_swift_ast "0007", """
    protocol A {}
    class B {}
    struct C {}
    enum D {}  

    struct E {
      let a: A
      var b: B
      let c: C
      var d: D
    }
    """#, skip_cache=true
    refute_includes(@unused.protocols, 'A')        
    refute_includes(@unused.classes, 'B')        
    refute_includes(@unused.structs, 'C')        
    refute_includes(@unused.enums, 'D')        

  end

  def test_used_items_in_function_return_types
    with_swift_ast "0009", """
    class A {}

    class C {
      func a() -> A {
        return A()
      }
    }
    """#, skip_cache=true
    refute_includes(@unused.classes, 'A')         
  end


  def test_used_items_in_function_parameters
    with_swift_ast "0010", """
    class A {}

    class C {
      func a(param: A){
      }
    }
    """#, skip_cache=true
    refute_includes(@unused.classes, 'A')         
  end

  def test_used_items_in_internal_variables
    with_swift_ast "0011", """
    class A {}

    func a(){
      let p = A()
      print(p)
    }
    """#, skip_cache=true
    refute_includes(@unused.classes, 'A')         
  end


  def with_swift_ast(id, source, skip_cache = false)
    require 'tempfile'
    generated_path =  "./test/fixtures/generated/"
    outpath = generated_path + "#{id}.ast"
    if !File.exist?(outpath) || skip_cache
      inpath = generated_path + "#{id}.swift"
      file = File.new(inpath, "w")
      # file = Tempfile.new(['unused-test', '.swift'])
      file.write(source)
      file.close
      %x(swiftc -dump-ast #{inpath} &> #{outpath} )
    end
    @unused = SwiftUnused.new({:ast_path => outpath})
    @unused.search
  end  

end
