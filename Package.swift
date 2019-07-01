// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "CoreSDK",
    products: [
        .library(name: "CoreSDK", targets: ["CoreSDK"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CoreSDK", path: "Core")
    ]
)

