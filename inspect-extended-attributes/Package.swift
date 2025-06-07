// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "inspect-extended-attributes",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "InspectExtendedAttributes",
            targets: ["InspectExtendedAttributes"])
    ],
    targets: [
        .executableTarget(
            name: "InspectExtendedAttributes")
    ]
)
