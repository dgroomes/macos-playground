// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "process-management",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ProcessManagement",
            targets: ["ProcessManagement"])
    ],
    targets: [
        .executableTarget(
            name: "ProcessManagement")
    ]
)
