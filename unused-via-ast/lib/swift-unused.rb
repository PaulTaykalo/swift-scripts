require 'swift-ast-dump/swift_ast_parser'
class SwiftUnused

  def initialize(ast_path)
    @ast_path = ast_path
    @tree = SwiftAST::Parser.new().parse_build_log_output(File.read(ast_path))

  end

  def search
    @used_classes = Hash.new
    @used_protocols = Hash.new

    unused_classes = []
    unused_protocols = []
    classes = @tree.find_nodes("class_decl")
    protocols = @tree.find_nodes("protocol")   


    classes.each { |classnode|
      register_inheritance(classnode) { |inh| @used_classes[inh] = "inherited" }
    }

    protocols.each { |protocolnode|
      register_inheritance(protocolnode) { |inh| @used_protocols[inh] = "inherited"}
    }

    classes.each { |node| 
      next unless classname = node.parameters.first
      next unless @used_classes[classname].nil? #// skip already used classes
      unused_classes += [classname]
    }

    protocols.each { |node| 
      next unless protocol_name = node.parameters.first
      next unless @used_protocols[protocol_name].nil? #// skip already used classes
      unused_protocols += [protocol_name]
    }

    @classes = unused_classes
    @protocols = unused_protocols
  end  

  def classes
    @classes
  end  

  def protocols
    @protocols
  end 

  def register_inheritance(node, &block)
    inheritance = node.parameters.drop_while { |el| el != "inherits:" }
    inheritance = inheritance.drop(1)
    inheritance.each { |inh| 
      inh_name = inh.chomp(",")
      yield inh_name
    }
  end

  def add_usage(inh_name, type)
    @used_classes[inh_name] = type
  end  

end