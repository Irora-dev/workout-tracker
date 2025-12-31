// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CosmosIntel",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "CosmosIntel",
            targets: ["CosmosIntel"]
        ),
    ],
    dependencies: [
        .package(path: "../CosmosCore")
    ],
    targets: [
        .target(
            name: "CosmosIntel",
            dependencies: ["CosmosCore"]
        ),
        .testTarget(
            name: "CosmosIntelTests",
            dependencies: ["CosmosIntel"]
        ),
    ]
)
