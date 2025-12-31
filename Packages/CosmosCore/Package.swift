// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CosmosCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "CosmosCore",
            targets: ["CosmosCore"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CosmosCore",
            dependencies: []
        ),
        .testTarget(
            name: "CosmosCoreTests",
            dependencies: ["CosmosCore"]
        ),
    ]
)
