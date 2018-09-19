//
//  main.swift
//  UnusedSwift
//
//  Created by Paul Taykalo on 8/16/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

import Foundation
import SwiftSyntax


/// AddOneToIntegerLiterals will visit each token in the Syntax tree, and
/// (if it is an integer literal token) add 1 to the integer and return the
/// new integer literal token.
class AddOneToIntegerLiterals: SyntaxRewriter {
    override func visit(_ token: TokenSyntax) -> Syntax {
        // Only transform integer literals.
        guard case .integerLiteral(let text) = token.tokenKind else {
            return token
        }

        // Remove underscores from the original text.
        let integerText = String(text.filter { ("0"..."9").contains($0) })

        // Parse out the integer.
        let int = Int(integerText)!

        // Return a new integer literal token with `int + 1` as its text.
        return token.withKind(.integerLiteral("\(int + 1)"))
    }
}

let file = CommandLine.arguments[1]
let url = URL(fileURLWithPath: file)
let sourceFile = try SourceFileSyntax.parse(url)
let incremented = AddOneToIntegerLiterals().visit(sourceFile)
print(incremented)
print("cool")
