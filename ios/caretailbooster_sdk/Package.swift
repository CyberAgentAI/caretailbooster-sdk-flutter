// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "caretailbooster_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "CaRetailBoosterSDK", targets: ["caretailbooster_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/CyberAgentAI/caretailbooster-sdk-ios.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "caretailbooster_sdk",
            dependencies: [
                .product(name: "CaRetailBoosterSDK", package: "caretailbooster-sdk-ios")
            ]
        )
    ]
)
