// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v12)
        ],
        products: [
            .executable(name: "MacOSPlayground", targets: ["MacOSPlayground"]),
        ],
        targets: [
            .executableTarget(name: "MacOSPlayground")
        ]
)
