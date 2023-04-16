// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v12)
        ],
        products: [
            .executable(name: "PrintEnv", targets: ["PrintEnv"]),
            .executable(name: "InspectExtendedAttributes", targets: ["InspectExtendedAttributes"]),
            .executable(name: "ProcessManagement", targets: ["ProcessManagement"])
        ],
        targets: [
            .executableTarget(name: "PrintEnv"),
            .executableTarget(name: "InspectExtendedAttributes"),
            .executableTarget(name: "ProcessManagement")
        ]
)
