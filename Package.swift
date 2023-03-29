// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v12)
        ],
        products: [
            .executable(name: "PrintEnv", targets: ["PrintEnv"]),
            .executable(name: "InspectExtendedAttributes", targets: ["InspectExtendedAttributes"])
        ],
        targets: [
            .executableTarget(name: "PrintEnv"),
            .executableTarget(name: "InspectExtendedAttributes")
        ]
)
