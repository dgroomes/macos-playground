// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "secrets",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "Secrets",
            targets: ["Secrets"])
    ],
    targets: [
        .executableTarget(
            name: "Secrets")
    ]
)
