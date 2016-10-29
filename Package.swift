import PackageDescription

let package = Package(
	name: "Ji",
	dependencies: [
        .Package(url: "https://github.com/Zewo/CLibXML2.git", majorVersion: 0, minor: 6)
    ],
	exclude: [
		"Source/Info.plist",
		"Source/Ji.h",
		"Source/Ji.swift",
		"Source/JiHelper.swift",
		"Source/JiNode.swift",
		"Tests/",
		"Tests/Info.plist",
		"Tests/TestData"
	]
)
