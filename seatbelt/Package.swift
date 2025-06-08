// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Seatbelt",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "Seatbelt",
            targets: ["Seatbelt"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Seatbelt"
        )
    ]
)
