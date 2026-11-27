// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hyper_webview_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "hyper-webview-flutter", targets: ["hyper_webview_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "hyper_webview_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
