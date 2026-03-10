// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Specta",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "Specta",
            targets: ["Specta"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Specta",
            dependencies: [],
            path: "Sources",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "SpectaTests",
            dependencies: ["Specta"],
            path: "Tests"
        ),
    ]
)
