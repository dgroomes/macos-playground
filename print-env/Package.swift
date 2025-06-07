// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "print-env",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "PrintEnv",
            targets: ["PrintEnv"])
    ],
    targets: [
        .executableTarget(
            name: "PrintEnv")
    ]
)
