// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CosmosUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "CosmosUI",
            targets: ["CosmosUI"]
        ),
    ],
    dependencies: [
        .package(path: "../CosmosCore")
    ],
    targets: [
        .target(
            name: "CosmosUI",
            dependencies: ["CosmosCore"]
        )
    ]
)
