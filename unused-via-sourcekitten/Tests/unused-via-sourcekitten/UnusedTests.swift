import SourceKittenFramework
import XCTest
import UnusedFramework

let fixturesDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().path + "/Fixtures/"

class UnusedTests: XCTestCase {

    func testUnusedClass() {
        let sut = generateSut(source: """
           class Unused {}
        """)
        let unusedItem = sut.unusedItems.first
        XCTAssertNotNil(unusedItem)
        XCTAssertTrue(unusedItem?.name == "Unused")
        XCTAssertTrue(unusedItem?.type == .class)
    }

    func testUsedClass() {
        let sut = generateSut(source: """
           class Used {}
           class Unused: Used {}
        """)
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "Used" }))
        XCTAssert(sut.unusedItems.contains(where: { $0.name == "Unused" }))
    }

    func testUnusedProtocol() {
        let sut = generateSut(source: """
           protocol UnusedProtocol {}
        """)
        let unusedItem = sut.unusedItems.first
        XCTAssertNotNil(unusedItem)
        XCTAssertTrue(unusedItem?.name == "UnusedProtocol")
        XCTAssertTrue(unusedItem?.type == .protocol)
    }

    func testUsedProtocol() {
        let sut = generateSut(source: """
           protocol Used {}
           protocol Unused: Used {}
        """)
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "Used" }))
        XCTAssert(sut.unusedItems.contains(where: { $0.name == "Unused" }))
    }

    func testUnusedStruct() {
        let sut = generateSut(source: """
           struct UnusedStruct {}
        """)
        let unusedItem = sut.unusedItems.first
        XCTAssertNotNil(unusedItem)
        XCTAssertTrue(unusedItem?.name == "UnusedStruct")
        XCTAssertTrue(unusedItem?.type == .struct)
    }

    func testUsedInProtocolVariable() {
        let sut = generateSut(source: """
           protocol UsedProtocol {}
           struct UsedStruct {}
           class UsedClass {}

           protocol Unused {
             var a: UsedProtocol { get }
             var b: UsedStruct { get }
             var c: UsedClass { get }
            }
        """)
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedProtocol" }))
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedStruct" }))
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedClass" }))

        XCTAssert(sut.unusedItems.contains(where: { $0.name == "Unused" }))

    }

    func testUsedInProtocolTypeAlias() {
        let sut = generateSut(source: """
           protocol UsedProtocol {}
           struct UsedStruct {}
           class UsedClass {}

           protocol Unused {
             typealias a = UsedProtocol
             typealias b = UsedStruct
             typealias c = UsedClass
            }
        """)
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedProtocol" }))
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedStruct" }))
        XCTAssert(!sut.unusedItems.contains(where: { $0.name == "UsedClass" }))

        XCTAssert(sut.unusedItems.contains(where: { $0.name == "Unused" }))

    }


    private func generateSut(source: String) -> Unused {
        return Unused(source: source)
    }
}

