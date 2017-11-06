// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "unused-via-sourcekitten",
    products: [
        .executable(name: "unused-via-sourcekitten", targets: ["unused-via-sourcekitten"]),
        .library(name: "UnusedFramework", targets: ["UnusedFramework"])

    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.18.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "unused-via-sourcekitten",
            dependencies: ["UnusedFramework"], 
            path: "Sources/unused-via-sourcekitten"
        ),
        .target(
            name: "UnusedFramework",
            dependencies: ["SourceKittenFramework"], 
            path: "Sources/UnusedFramework"
        ),
        .testTarget(
            name: "unused-via-sourcekittenTests",
            dependencies: ["UnusedFramework"],
            path: "Tests/unused-via-sourcekitten",
            exclude: [
                "Fixtures"
            ]
        )
    ]


)


