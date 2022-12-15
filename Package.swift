// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "smart-motor",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UI",
            targets: ["UI"]
        ),
        .library(
            name: "Configurations",
            targets: ["Configurations"]
        ),
        .library(
            name: "Train",
            targets: ["Train"]
        ),
        .library(
            name: "Run",
            targets: ["Run"]
        ),
        .library(
            name: "AppCore",
            targets: ["AppCore"]
        ),
        .library(name: "MQTTCore", targets: ["MQTTCore"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "0.47.2")),
        .package(url: "https://github.com/sroebert/mqtt-nio.git", from: "2.8.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Train",
                "Run",
                "Configurations"
            ]
        ),
        .target(
            name: "Run",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                
            ]
        ),
        .target(
            name: "Configurations",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                
            ]
        ),
        .target(
            name: "Train",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "MQTTCore",
                
            ]
        ),
        .target(
            name: "AppCore",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"),
                "UI"
                
            ]
        ),
        .target(
            name: "MQTTCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "MQTTNIO", package: "mqtt-nio")
            ]
        ),
        
        
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]),
    ]
)
