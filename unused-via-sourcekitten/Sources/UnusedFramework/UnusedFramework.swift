import SourceKittenFramework

public class Unused {

    public enum ItemType: String {
        case `class`
        case `protocol`
        case `struct`
    }

    public struct Item: Hashable {
        public var hashValue: Int {
            return (name.hashValue << 16) ^ type.hashValue
        }

        public static func ==(lhs: Unused.Item, rhs: Unused.Item) -> Bool {
            return lhs.name == rhs.name && rhs.type == lhs.type
        }

        public let name: String
        public let type: ItemType
    }

    enum Ref {
        case name(String)
        case item(Item)
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

    var usage:[Unused.Item: Int] = [:]

    private let root: [String: SourceKitRepresentable]
    init(root: [String: SourceKitRepresentable]) {
        self.root = root
    }

    func items() -> [Unused.Item] {
        return items(from: root).filter { usage[$0] == nil }
    }

    private func items(from node: [String: SourceKitRepresentable]) -> [Unused.Item] {
        var items = [Unused.Item] ()
        if node.kind(.class) {
            items.append(.init(name: node.name(), type: .class))
        }
        if node.kind(.protocol) {
            items.append(.init(name: node.name(), type: .protocol))
        }

        if node.kind(.struct) {
            items.append(.init(name: node.name(), type: .struct))
        }

        node.inheritedTypes().forEach { name in
            registerUsages(for: name)
        }

        node.typeName().map(registerUsages)

        let moreItems = node.substructure().flatMap({ self.items(from: $0)})
        return items + moreItems
    }

    private func registerUsages(for name: String) {
        let types : [Unused.ItemType] = [ .class, .protocol, .struct ]
        types.forEach {
            let item = Unused.Item(name: name, type: $0)
            usage[item] = (usage[item] ?? 0) + 1
        }
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

    func typeName() -> String? {
        return self["key.typename"] as? String
    }

    func inheritedTypes() -> [String] {
        return (self["key.inheritedtypes"] as? [[String: SourceKitRepresentable]] ?? []).map { $0.name() }
    }
}
