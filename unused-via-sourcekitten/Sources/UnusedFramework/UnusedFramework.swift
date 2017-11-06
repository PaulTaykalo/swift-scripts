import SourceKittenFramework

public class Unused {

    public enum ItemType: String {
        case `class`
        case `protocol`
    }

    public struct Item {
        public let name: String
        public let type: ItemType
    }

    private let source: String
    public init(source: String) {
        self.source = source
    }

    public private(set) lazy var unusedItems: [Item] = generateUnused()

    private func generateUnused() -> [Item] {
        let s = Structure(file: File(contents: source))
        print("structure \(s)")
        let traverser = StructureTraveser(root: s.dictionary)
        let items = traverser.items()
        return items
    }
    
}


private class StructureTraveser {
    private let root: [String: SourceKitRepresentable]
    init(root: [String: SourceKitRepresentable]) {
        self.root = root
    }

    func items() -> [Unused.Item] {
        return items(from: root)
    }

    private func items(from node: [String: SourceKitRepresentable]) -> [Unused.Item] {
        var items = [Unused.Item] ()
        if node.kind(.class) {
            items.append(.init(name: node.name(), type: .class))
        }
        if node.kind(.protocol) {
            items.append(.init(name: node.name(), type: .protocol))
        }

        let moreItems = node.substructure().flatMap({ self.items(from: $0)})
        return items + moreItems
    }

}

fileprivate extension Dictionary where Key == String, Value == SourceKitRepresentable {
    func substructure() -> [[String: SourceKitRepresentable]] {
        return self["key.substructure"] as? [[String: SourceKitRepresentable]] ?? []
    }
    func kind(_ kind: SwiftDeclarationKind) -> Bool {
        return self["key.kind"]?.isEqualTo(kind.rawValue) == true
    }
    func name() -> String {
        return (self["key.name"] as? String) ?? ""
    }
}
