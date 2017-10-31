require "swift-ast-dump/swift_ast_parser"

tree = SwiftAST::Parser.new().parse_build_log_output(File.read("/Users/paultaykalo/Projects/rageon/ios-app2/RageOn-old.ast"))
tree.dump()
