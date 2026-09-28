// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ItIsMyGallery",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ItIsMyGallery",
            targets: ["ItIsMyGallery"]
        )
    ],
    targets: [
        .target(
            name: "ItIsMyGallery",
            path: "Sources/ItIsMyGallery"
        ),
        .testTarget(
            name: "ItIsMyGalleryTests",
            dependencies: ["ItIsMyGallery"],
            path: "Tests/ItIsMyGalleryTests"
        )
    ]
)
