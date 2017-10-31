require 'swift-ast-dump/swift_ast_parser'
class SwiftUnused

  def initialize(ast_path)
    @ast_path = ast_path
    @tree = SwiftAST::Parser.new().parse_build_log_output(File.read(ast_path))
  end

  def classes
    result = []
    classes = @tree.find_nodes("class_decl")
    classes.each { |node| 
      next unless classname = node.parameters.first
      result += [classname]
    }

    result
  end  

end