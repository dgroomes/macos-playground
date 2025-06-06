// swift-tools-version:5.8

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v13)
        ],
        products: [
            .executable(name: "PrintEnv", targets: ["PrintEnv"]),
            .executable(name: "InspectExtendedAttributes", targets: ["InspectExtendedAttributes"]),
            .executable(name: "ProcessManagement", targets: ["ProcessManagement"]),
            .executable(name: "Secrets", targets: ["Secrets"]),
            .executable(name: "RestoreImage", targets: ["RestoreImage"])
        ],
        targets: [
            .executableTarget(name: "PrintEnv"),
            .executableTarget(name: "InspectExtendedAttributes"),
            .executableTarget(name: "ProcessManagement"),
            .executableTarget(name: "Secrets"),
            .executableTarget(name: "RestoreImage")
        ]
)
