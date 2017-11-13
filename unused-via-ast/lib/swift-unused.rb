require 'swift-ast-dump/swift_ast_parser'
class SwiftUnused

  def initialize(options)
    ast_path = options[:ast_path]
    source = options[:source]
    @tree = SwiftAST::Parser.new().parse_build_log_output(File.read(ast_path)) if ast_path
    @tree = SwiftAST::Parser.new().parse_build_log_output(source) if source
  end

  def search
    @used_classes = Hash.new
    @used_protocols = Hash.new
    @used_structs = Hash.new
    @used_enums = Hash.new

    unused_classes = []
    unused_protocols = []
    unused_structs = []
    unused_enums = []
    classes = @tree.find_nodes("class_decl")
    protocols = @tree.find_nodes("protocol")   
    extensions = @tree.find_nodes("extension_decl")   
    structs = @tree.find_nodes("struct_decl")
    enums = @tree.find_nodes("enum_decl")

    classes.each { |classnode|
      register_inheritance(classnode) { |inh| 
        @used_classes[inh] = "inherited" 
        @used_protocols[inh] = "inherited" # we aren't gathering info what string is, so we'll just mark the as P and Classes
      }
    }

    protocols.each { |protocolnode|
      register_inheritance(protocolnode) { |inh| @used_protocols[inh] = "inherited"}
    }

    extensions.each { |extension_node|
      register_inheritance(extension_node) { |inh| @used_protocols[inh] = "inherited"}
    }

    structs.each { |struct_node|
      register_inheritance(struct_node) { |inh| @used_protocols[inh] = "inherited"}
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

    structs.each { |node|
      next unless struct_name = node.parameters.first
      next unless @used_structs[struct_name].nil? #// skip already used structs
      unused_structs += [struct_name]
    }

    enums.each { |node|
      next unless enum_name = node.parameters.first
      next unless @used_enums[enum_name].nil? #// skip already used structs
      unused_enums += [enum_name]
    }

    @classes = unused_classes
    @protocols = unused_protocols
    @structs = unused_structs
    @enums = unused_enums
  end  

  def classes
    @classes
  end  

  def protocols
    @protocols
  end 

  def structs
    @structs
  end  

  def enums
    @enums
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