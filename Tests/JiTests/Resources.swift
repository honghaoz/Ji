import Foundation

struct Resource {
    static var sampleXMLPath: String? {
        #if XCODE
        return URL(string: "sample.xml", relativeTo: Bundle(for: JiTests.self).resourceURL)?.path
        #else
        let filePath = "\(_testsResourcesDirectory)/sample.xml"
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
        #endif
    }

    static var sampleHTMLPath: String? {
        #if XCODE
        return URL(string: "sample.html", relativeTo: Bundle(for: JiTests.self).resourceURL)?.path
        #else
        let filePath = "\(_testsResourcesDirectory)/sample.html"
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
        #endif
    }

    /// Returns path to the built products directory.
    static private var _productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    /// Returns path to test resources directory.
    static private var _testsResourcesDirectory: String {
        let resourcesDirectory = "\(_productsDirectory.path)/../../../Tests/Resources"
        if FileManager.default.fileExists(atPath: resourcesDirectory) {
            return resourcesDirectory
        }

        if let rootDirectory = ProcessInfo.processInfo.environment["ROOT_DIR"] {
            let resourcesDirectory = ("\(rootDirectory)/Tests/Resources" as NSString).expandingTildeInPath
            if FileManager.default.fileExists(atPath: resourcesDirectory) {
                return resourcesDirectory
            }
        }

        assertionFailure("Missing Tests/Resources directory.\n" +
            "If run in Xcode, please set env variable 'ROOT_DIR' to current project directory.")
        return ""
    }
}


