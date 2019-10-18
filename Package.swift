// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "IBMIoTClient",
    products: [
        .library(name: "IBMIoTClient", targets: ["IBMIoTClient"]),
    ],
    targets: [
        .target(
            name: "IBMIoTClient",
        .testTarget(
            name: "IBMIoTClientTests",
            dependencies: ["IBMIoTClient"]),
    ]
)