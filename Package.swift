// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ImageViewer_swift",
	platforms: [
		.iOS(.v10)
	],
    products: [
        .library(
            name: "ImageViewer_swift",
            targets: ["ImageViewer_swift"])
	],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage", .upToNextMajor(from: "5.11.0")),
    ],
	targets: [
		.target(
			name: "ImageViewer_swift",
			dependencies: ["SDWebImage"],
			path: "Sources/ImageViewer_swift")
	]
)