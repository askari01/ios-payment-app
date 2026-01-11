// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PaymentSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "PaymentSDK",
            targets: ["PaymentSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PaymentSDK",
            dependencies: [],
            path: "PaymentSDK/Sources/PaymentSDK"
        ),
        .testTarget(
            name: "PaymentSDKTests",
            dependencies: ["PaymentSDK"]
        ),
    ]
)
