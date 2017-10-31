require 'swift-ast-dump/swift_ast_parser'
class SwiftUnused

  def initialize(ast_path)
    @ast_path = ast_path
    @tree = SwiftAST::Parser.new().parse_build_log_output(File.read(ast_path))
    @used_classes = Hash.new
  end

  def classes
    result = []
    classes = @tree.find_nodes("class_decl")
    classes.each { |classnode|
      register_inheritance(classnode)
    }
    classes.each { |node| 
      next unless classname = node.parameters.first
      next unless @used_classes[classname].nil? #// skip already used classes
      result += [classname]
    }
    result
  end  

  def register_inheritance(node)
    inheritance = node.parameters.drop_while { |el| el != "inherits:" }
    inheritance = inheritance.drop(1)
    inheritance.each { |inh| 
      inh_name = inh.chomp(",")
      add_usage(inh_name, "inheritance")
    }
  end

  def add_usage(inh_name, type)
    @used_classes[inh_name] = type
  end  

end