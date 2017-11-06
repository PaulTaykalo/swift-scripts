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

    func testUnusedProtocol() {
        let sut = generateSut(source: """
           protocol UnusedProtocol {}
        """)
        let unusedItem = sut.unusedItems.first
        XCTAssertNotNil(unusedItem)
        XCTAssertTrue(unusedItem?.name == "UnusedProtocol")
        XCTAssertTrue(unusedItem?.type == .protocol)
    }

    private func generateSut(source: String) -> Unused {
        return Unused(source: source)
    }
}

