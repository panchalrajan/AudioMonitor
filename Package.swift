// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "AudioMonitor",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AudioMonitor",
            targets: ["AudioMonitor"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AudioMonitor",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
