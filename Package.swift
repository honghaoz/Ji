// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "Ji",
	products: [
		.library(
			name: "Ji",
			targets: ["Ji"]
        ),
	],
    targets: [
        .systemLibrary(
            name: "Clibxml2",
            pkgConfig: "libxml-2.0",
            providers: [
                .brew(["libxml2"]),
                .apt(["libxml2-dev"])
            ]
        ),
        .target(
            name: "Ji",
            dependencies: ["Clibxml2"]
        ),
        .testTarget(
            name: "JiTests",
            dependencies: ["Ji"]
        ),
    ]
)
