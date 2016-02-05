//
//  JiNodeHTMLTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-22.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
@testable import Ji

class JiNodeHTMLTests: XCTestCase {
	var sampleHTMLDocument: Ji!
	var rootNode: JiNode!
	
	override func setUp() {
		super.setUp()
		let testBundle = NSBundle(forClass: self.dynamicType)
		let fileURL = testBundle.URLForResource("index", withExtension: "html")!
		let htmlData = NSData(contentsOfURL: fileURL)!
		sampleHTMLDocument = Ji(htmlData: htmlData)
		rootNode = sampleHTMLDocument.rootNode
	}
	
	override func tearDown() {
		// Put teardown code here.
		super.tearDown()
	}
	
	func testDocumentsInitialized() {
		XCTAssertNotNil(sampleHTMLDocument)
	}

	func testRootNodeExists() {
		XCTAssertNotNil(rootNode)
	}

	// MARK: - Name / TagName
	func testNodeName() {
		XCTAssertEqual(rootNode.name!, "html")
	}

	func testNodeTagName() {
		XCTAssertEqual(rootNode.tagName!, "html")
	}

	// MARK: - Children
	func testChildrenCount() {
		rootNode.keepTextNode = false
		XCTAssertEqual(rootNode.children.count, 2)
		
		XCTAssertEqual(rootNode.firstChild!.children.count, 25)
		
		rootNode.keepTextNode = true
		XCTAssertEqual(rootNode.children.count, 5)
	}
	
	func testHasChildren() {
		XCTAssertTrue(rootNode.hasChildren)
		
		let nodeHasNoChildren = rootNode.xPath("./head/meta").first!
		XCTAssertFalse(nodeHasNoChildren.hasChildren)
	}
	
	// MARK: - firstChild
	func testFirstChildNotNil() {
		XCTAssertNotNil(rootNode.firstChild)
		XCTAssertEqual(rootNode.firstChild!.name!, "head")
		
		XCTAssertNotNil(rootNode.firstChild!.firstChild)
		XCTAssertEqual(rootNode.firstChild!.firstChild!.name!, "meta")
		XCTAssertEqual(rootNode.firstChild!.firstChild!.content!, "")
	}
	
	func testFirstChildIsNil() {
		XCTAssertNil(rootNode.firstChild!.firstChild!.firstChild)
	}
	
	func testFirstChildKeppTextNode() {
		rootNode.keepTextNode = false
		XCTAssertNotNil(rootNode.firstChild)
		XCTAssertNotEqual(rootNode.firstChild!.name!, "text")
		
		rootNode.keepTextNode = true
		XCTAssertNotNil(rootNode.firstChild)
		XCTAssertEqual(rootNode.firstChild!.keepTextNode, rootNode.keepTextNode)
		XCTAssertEqual(rootNode.firstChild!.name!, "text")
		
		XCTAssertNil(rootNode.firstChild!.firstChild)
	}
	
	// MARK: - lastChild
	func testLastChildNotNil() {
		XCTAssertNotNil(rootNode.lastChild)
		XCTAssertEqual(rootNode.lastChild!.name!, "body")
		
		XCTAssertNotNil(rootNode.lastChild!.lastChild)
		XCTAssertEqual(rootNode.lastChild!.lastChild!.name!, "div")
	}
	
	func testLastChildIsNil() {
		let node = rootNode.xPath("./body/div/div/div/ul[@class='piped']/li[last()]/a").first!
		XCTAssertEqual(node.name!, "a")
		XCTAssertNil(node.lastChild)
	}
	
	func testLastChilddKeppTextNode() {
		rootNode.keepTextNode = false
		XCTAssertNotNil(rootNode.lastChild)
		XCTAssertNotEqual(rootNode.lastChild!.name!, "text")
		
		rootNode.keepTextNode = true
		XCTAssertNotNil(rootNode.lastChild)
		XCTAssertEqual(rootNode.lastChild!.name!, "text")
		
		XCTAssertNil(rootNode.lastChild!.lastChild)
	}
	
	// MARK: - parent
	func testRootNodeParentTypeIsDoc() {
		XCTAssertEqual(rootNode.parent!.type, JiNodeType.HtmlDocument)
	}
	
	func testLastChildNodeParentIsRootNode() {
		XCTAssertTrue(rootNode.lastChild?.parent == rootNode)
	}
	
	// MARK: - nextSibling
	func testNextSibling() {
		let head = rootNode.firstChild!
		XCTAssertNotNil(head.nextSibling)
		XCTAssertEqual(head.nextSibling!.name!, "body")
	}
	
	func testNextSiblingKeepTextNode() {
		var head = rootNode.firstChild!
		XCTAssertNotNil(head.nextSibling)
		XCTAssertEqual(head.nextSibling!.name!, "body")
		
		rootNode.keepTextNode = true
		head = rootNode.xPath("./head").first!
		XCTAssertEqual(head.keepTextNode, rootNode.keepTextNode)
		let textNode = head.nextSibling
		XCTAssertNotNil(textNode)
		XCTAssertEqual(textNode!.name!, "text")
	}
	
	// MARK: - previousSibling
	func testLastPreviousSibling() {
		let secondMeta = rootNode.xPath("./head/meta[2]").first!
		XCTAssertNotNil(secondMeta.previousSibling)
		XCTAssertEqual(secondMeta.previousSibling!["http-equiv"]!, "content-type")
	}
	
	func testPreviousSiblingKeepTextNode() {
		var head = rootNode.xPath("./head").first!
		XCTAssertNotNil(head)
		
		rootNode.keepTextNode = true
		head = rootNode.xPath("./head").first!
		let previouTextNode = head.previousSibling
		XCTAssertNotNil(previouTextNode)
		XCTAssertEqual(previouTextNode!.keepTextNode, rootNode.keepTextNode)
		XCTAssertEqual(previouTextNode!.name!, "text")
	}
	
	// MARK: - Content
	func testRawContent() {
		let macNode = rootNode.xPath("//a[@href='/support/mac/']/p").first!
		XCTAssertEqual(macNode.rawContent!, "<p> Mac </p>")
	}
	
	func testContent() {
		let macNode = rootNode.xPath("//a[@href='/support/mac/']/p").first!
		XCTAssertEqual(macNode.content!, " Mac ")
	}
	
	// MARK: - Value
	func testValue() {
		let macNode = rootNode.xPath("//a[@href='/support/mac/']/p").first!
		XCTAssertEqual(macNode.value!, " Mac ")
	}
	
	// MARK: - Attribute
	func testSubscriptAttribute() {
		XCTAssertEqual(rootNode["xmlns"]!, "http://www.w3.org/1999/xhtml")
		XCTAssertEqual(rootNode["xml:lang"]!, "en-US")
		XCTAssertEqual(rootNode["lang"]!, "en-US")
		XCTAssertEqual(rootNode["class"]!, "no-js")
		XCTAssertEqual(rootNode.firstChild!.firstChild!["http-equiv"]!, "content-type")
	}

	func testAttributes() {
		XCTAssertEqual(rootNode.attributes.count, 4)
		
		XCTAssertEqual(rootNode.attributes["xmlns"]!, "http://www.w3.org/1999/xhtml")
		XCTAssertEqual(rootNode.attributes["xml:lang"]!, "en-US")
		XCTAssertEqual(rootNode.attributes["lang"]!, "en-US")
		XCTAssertEqual(rootNode.attributes["class"]!, "no-js")
	}
	
	// MARK: - Search Children
	func testFirstChildWithName() {
		let head = rootNode.firstChild!
		XCTAssertNil(head.firstChildWithName("head"))
		
		let linkNode = head.firstChildWithName("link")
		XCTAssertNotNil(linkNode)
		XCTAssertEqual(linkNode!["type"]!, "text/css")
	}
	
	func testChildrenWithName() {
		let head = rootNode.firstChild!
		XCTAssertEqual(head.childrenWithName("meta").count, 8)
		XCTAssertEqual(head.childrenWithName("title").count, 1)
	}
	
	func testFirstChildWithAttributeValue() {
		let head = rootNode.firstChild!
		XCTAssertEqual(head.firstChildWithAttributeName("name", attributeValue: "Keywords")!.name!, "meta")
	}
	
	func testChildrenWithAttributeNameValue() {
		let head = rootNode.firstChild!
		XCTAssertEqual(head.childrenWithAttributeName("rel", attributeValue: "stylesheet").count, 3)
	}
	
	// MARK: - Search Descendants
	func testFirstDescendantWithName() {
		XCTAssertNil(rootNode.firstDescendantWithName("html"))
		XCTAssertEqual(rootNode.firstDescendantWithName("link")!["id"]!, "global-font")
	}
	
	func testDescendantsWithName() {
		XCTAssertEqual(rootNode.descendantsWithName("html").count, 0)
		XCTAssertEqual(rootNode.descendantsWithName("link").count, 3)
	}
	
	func testFirstDescendantWithAttributeValue() {
		XCTAssertEqual(rootNode.firstDescendantWithAttributeName("id", attributeValue: "globalheader")!.name!, "nav")
	}
	
	func testDescendantsWithAttributeNameValue() {
		XCTAssertEqual(rootNode.descendantsWithAttributeName("rel", attributeValue: "stylesheet").count, 3)
	}
	
	// MARK: - Generator
	func testSequenceGenerator() {
		let head = rootNode.firstChild!
		for (index, node) in head.enumerate() {
			if index == 0 {
				XCTAssertEqual(node["http-equiv"]!, "content-type")
			} else if index == 1 {
				XCTAssertEqual(node["http-equiv"]!, "X-UA-Compatible")
			} else if index == 2 {
				XCTAssertEqual(node["http-equiv"]!, "Cache-Control")
			} else if index == 3 {
				XCTAssertEqual(node["name"]!, "viewport")
			}
		}
	}
	
	// MARK: - CustomStringConvertible
	func testCustomStringConvertible() {
		XCTAssertEqual("\(rootNode)", rootNode!.rawContent!)
	}
}
