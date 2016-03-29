import PackageDescription

let package = Package(
    name: "XML",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Data.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/String.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/VeniceX/File.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/CLibXML2.git", majorVersion: 0, minor: 4)
    ]
)