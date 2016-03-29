// Init with data
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


// Init with URL
let jiAppleSupportDoc = Ji(htmlURL: NSURL(string: "http://www.apple.com/support")!)
let titleNode = jiAppleSupportDoc?.xPath("//head/title")?.first
print("title: \(titleNode?.content)")


// Init with String
let xmlString = "<?xml version='1.0' encoding='UTF-8'?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>"
let xmlDoc = Ji(xmlString: xmlString)
let bodyNode = xmlDoc?.rootNode?.firstChildWithName("body")
print("body: \(bodyNode?.content)")

