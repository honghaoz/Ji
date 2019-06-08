// swift-tools-version:4.2

import PackageDescription

let package = Package(
	name: "Ji",
	products: [
		.library(
			name: "Ji",
			targets: ["Ji"]),
	],
    targets: [
        .systemLibrary(
                name: "Clibxml2",
                pkgConfig: "libxml-2.0",
                providers: [
                    .brew(["libxml2"]),
                    .apt(["libxml2-dev"])
                ]),
        .target(
            name: "Ji",
            dependencies: ["Clibxml2"],
            exclude: [
            	"Source/Info.plist",
				"Source/Ji.h",
				"Source/Ji.swift",
				"Source/JiHelper.swift",
				"Source/JiNode.swift",
            ]),
        .testTarget(
            name: "JiTests",
            dependencies: ["Ji"],
            exclude: [
            	"Tests/",
				"Tests/Info.plist",
				"Tests/TestData"
            ]),
    ]
)
