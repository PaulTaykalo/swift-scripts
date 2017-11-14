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
      register_variables(classnode, &method(:mark_as_used))
      register_func_types(classnode, &method(:mark_as_used)) 

    }

    protocols.each { |protocolnode|
      register_inheritance(protocolnode) { |inh| @used_protocols[inh] = "inherited"}
      register_func_types(protocolnode, &method(:mark_as_used)) 
    }

    extensions.each { |extension_node|
      register_inheritance(extension_node) { |inh| @used_protocols[inh] = "inherited"}
      register_func_types(extension_node, &method(:mark_as_used)) 
      register_variables(extension_node, &method(:mark_as_used))
    }

    structs.each { |struct_node|
      register_inheritance(struct_node) { |inh| @used_protocols[inh] = "inherited"}
      register_variables(struct_node, &method(:mark_as_used))
    }

    @tree.on_node('func_decl') { |func_decl|
      register_variables(func_decl, &method(:mark_as_used))
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

  def register_variables(node, &block)
    node.on_node("var_decl") { |var_node|
      return unless type_decl = var_node.parameters.detect { |el| el.start_with?("type=")}
      type = type_decl.split('=').last[1..-2]
      yield type
    }
  end  

  def register_func_types(node, &block)
    node.on_node("func_decl") { |func_decl|
      func_decl.on_node("parameter_list") { |parameter_list|
        parameter_list.on_node("parameter") { |parameter|
          type = type_from_node(parameter, 'type')
          yield type if  type
        }
      }

      func_decl.on_node("result") { |result|
        result.on_node("type_ident") { |type_ident|
          type_ident.on_node("component") { |component|
            type = type_from_node(component, 'id')
            yield type if type
          }
        }
      }
    }
  end  


  def type_from_node(node, attribute = "type")
    return nil unless type_decl = node.parameters.detect { |el| el.start_with?("#{attribute}=")}
    type = type_decl.split('=').last[1..-2]
  end  

  def add_usage(inh_name, type)
    @used_classes[inh_name] = type
  end  

  def mark_as_used(type)
    @used_classes[type] = "inherited" 
    @used_protocols[type] = "inherited" 
    @used_structs[type] = "inherited" 
    @used_enums[type] = "inherited" 
  end



end