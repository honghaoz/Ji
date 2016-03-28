XML
==========

[![Zewo][zewo-image]][zewo-url]
[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]
[![Slack][slack-badge]][slack-url]

XML is a Swift wrapper on libxml2 for parsing XML/HTML. 

## Features
- [x] Build XML/HTML Tree and Navigate
- [x] XPath Query Supported
- [x] Comprehensive Unit Test Coverage
- [ ] CSS Selector (on going)

## Usage

- Init with `String`:
```swift
let xmlString = "<?xml version='1.0' encoding='UTF-8'?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>"
let xmlDoc = XMLDocument(xmlString: xmlString)
let bodyNode = xmlDoc?.rootNode?.firstChildWithName("body")
print("body: \(bodyNode?.content)") // body: Optional("Don\'t forget me this weekend!")
```

- Init with `Data`:
```swift
let file = File(path: "~/Desktop/google.com.html")
let googleIndexData = try? file.read(file.length)
if let googleIndexData = googleIndexData {
	let xmlDoc = XMLDocument(htmlData: googleIndexData)!
	let htmlNode = xmlDoc.rootNode!
	print("html tagName: \(htmlNode.tagName)") // html tagName: Optional("html")
	
	let aNodes = xmlDoc.xPath("//body//a")
	if let firstANode = aNodes?.first {
		print("first a node tagName: \(firstANode.name)") // first a node tagName: Optional("a")
		let href = firstANode["href"]
		print("first a node href: \(href)") // first a node href: Optional("http://www.google.ca/imghp?hl=en&tab=wi")
	}
} else {
	print("can't read google.com.html")
}

```

## Installation

```bash
brew install libxml2
brew link --force libxml2
```

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Zewo/XML.git", majorVersion: 0, minor: 2)
    ]
)
```

## Community

[![Slack][slack-image]][slack-url]

The entire Zewo code base is licensed under MIT. By contributing to Zewo you are contributing to an open and engaged community of brilliant Swift programmers. Join us on [Slack](http://slack.zewo.io) to get to know us!

## License

**LibXML2** is released under the MIT license. See LICENSE for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platform-Mac%20%26%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
[travis-image]: https://travis-ci.org/antonmes/LibXML2.svg?branch=master
[travis-url]: https://travis-ci.org/antonmes/LibXML2
[zewo-image]: https://img.shields.io/badge/Zewo-0.3-FE3762.svg?style=flat
[zewo-url]: http://new.zewo.io
