// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v12)
        ],
        products: [
            .executable(name: "PrintPath", targets: ["PrintPath"]),
        ],
        targets: [
            .executableTarget(name: "PrintPath")
        ]
)
