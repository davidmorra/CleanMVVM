// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CharactersModule",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Presentation", targets: ["Presentation"]),
    ],
    dependencies: [
//        .package(path: "../Network")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "Data", dependencies: [
            "Domain",
//            "Network"
        ]),
        .target(name: "Domain", dependencies: []),
        .target(name: "Presentation", dependencies: [
            "Domain",
            "Data"
        ]),
    ]
)
