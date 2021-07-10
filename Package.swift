// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Portal",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Portal",
            targets: ["Portal"]
        ),
    ],
    targets: [
        .target(
            name: "Portal",
            dependencies: []
        ),
        .testTarget(
            name: "PortalTests",
            dependencies: ["Portal"]
        ),
    ]
)
