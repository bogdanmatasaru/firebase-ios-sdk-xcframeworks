// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Firebase",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v7)],
    products: [
        // GENERATE LIBRARIES
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Firebase",
            publicHeadersPath: "./"
        ),
        // GENERATE TARGETS
        // GENERATE BINARIES
    ]
)
