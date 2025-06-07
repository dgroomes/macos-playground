// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "restore-image",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "RestoreImage",
            targets: ["RestoreImage"])
    ],
    targets: [
        .executableTarget(name: "RestoreImage")
    ]
)
