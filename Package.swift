// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MobileCore",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "MobileCoreAPI_Generated", targets: ["MobileCoreAPI_Generated"]),
        .library(name: "MobileCore", targets: ["MobileCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.23.0")
    ],
    targets: [
        // Apollo-generated target
        .target(
            name: "MobileCoreAPI_Generated",
            dependencies: [
                .product(name: "ApolloAPI", package: "apollo-ios")
            ],
            path: "Sources/MobileCoreAPI_Generated"
        ),
        // Your main API target
        .target(
            name: "MobileCore",
            dependencies: [
                .product(name: "ApolloAPI", package: "apollo-ios"),
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloWebSocket", package: "apollo-ios"),
                "MobileCoreAPI_Generated"],
            path: "Sources/MobileCore"
        ),
        .testTarget(
            name: "MobileCoreTests",
            dependencies: [
                "MobileCore",
                "MobileCoreAPI_Generated",
                .product(name: "Apollo", package: "apollo-ios")
            ],
            path: "Tests/MobileCoreTests" // must match the actual folder
        )
    ]
)
