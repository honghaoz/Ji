import PackageDescription

let package = Package(
    name: "XML",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Data.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Zewo/String.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Zewo/File.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Zewo/CLibXML2.git", majorVersion: 0, minor: 1)
    ]
)