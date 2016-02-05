//
//  JiNodeXMLTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-22.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
@testable import Ji

class JiNodeXMLTests: XCTestCase {
	var sampleMenuXMLDocument: Ji!
	var rootNode: JiNode!
	
	override func setUp() {
		super.setUp()
		let xmlFileURL = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: self.dynamicType).resourceURL)!
		sampleMenuXMLDocument = Ji(xmlURL: xmlFileURL)
		rootNode = sampleMenuXMLDocument.rootNode
	}
	
	override func tearDown() {
		// Put teardown code here.
		super.tearDown()
	}
	
	func testDocumentsInitialized() {
		XCTAssertNotNil(sampleMenuXMLDocument)
	}
	
	func testRootNodeExists() {
		XCTAssertNotNil(rootNode)
	}
	
	// MARK: - Name / TagName
	func testNodeName() {
		XCTAssertEqual(rootNode.name!, "breakfast_menu")
	}
	
	func testNodeTagName() {
		XCTAssertEqual(rootNode.tagName!, "breakfast_menu")
	}
	
	// MARK: - Children
	func testChildrenCount() {
		rootNode.keepTextNode = false
		XCTAssertEqual(rootNode.children.count, 9)
		
		rootNode.keepTextNode = true
		XCTAssertEqual(rootNode.children.count, 19)
	}
	
	func testChildrenAllNameIsMatched() {
		for i in 0 ..< rootNode.children.count {
			if i == 2 {
				XCTAssertEqual(rootNode.children[i].name!, "not_food")
				continue
			}
			// Make sure empty node is not ignored
			if i == 3 {
				XCTAssertEqual(rootNode.children[i].name!, "empty_food")
				continue
			}
			if i == 4 || i == 5 {
				XCTAssertEqual(rootNode.children[i].name!, "comment")
				continue
			}
			XCTAssertEqual(rootNode.children[i].name!, "food")
		}
	}
	
	func testChildrenAllNameIsMatchedKeepTextNode() {
		rootNode.keepTextNode = false
		let previousChildrenNodeCount = rootNode.children.count
		XCTAssertTrue(previousChildrenNodeCount > 0)
		
		// If keepTextNode is changed, children should be recalculated
		rootNode.keepTextNode = true
		XCTAssertEqual(rootNode.children.count, previousChildrenNodeCount * 2 + 1)
		for i in 0 ..< rootNode.children.count {
			XCTAssertEqual(rootNode.children[i].keepTextNode, rootNode.keepTextNode)
			if i % 2 == 0 {
				XCTAssertEqual(rootNode.children[i].name!, "text")
			}
		}
	}
	
	// MARK: - Children Value Matched
	func testCertainChildrenValueMatched() {
		XCTAssertEqual(rootNode.children[1].children[2].value!, "Light Belgian waffles covered with strawberries and whipped cream")
		XCTAssertEqual(rootNode.children[1].children[1].value!, "$7.95")
		
		XCTAssertEqual(rootNode.children[2].children[0].value!, "foo")
		XCTAssertEqual(rootNode.children[2].children[1].name!, "test_content")
	}
	
	func testTextChildrenValueMatched() {
		rootNode.keepTextNode = false
		
		rootNode.keepTextNode = true
		let textNode = rootNode.children[2]
		XCTAssertEqual(textNode.name!, "text")
		XCTAssertEqual(textNode.content!, "some text\n\t")
	}
	
	func testHasChildren() {
		XCTAssertTrue(rootNode.hasChildren)
		
		let nodeHasNoChildren = rootNode.firstChild!.firstChild!
		XCTAssertFalse(nodeHasNoChildren.hasChildren)
	}
	
	// MARK: - firstChild
	func testFirstChildNotNil() {
		XCTAssertNotNil(rootNode.firstChild)
		XCTAssertEqual(rootNode.firstChild!.name!, "food")
		
		XCTAssertNotNil(rootNode.firstChild!.firstChild)
		XCTAssertEqual(rootNode.firstChild!.firstChild!.name!, "name")
		XCTAssertEqual(rootNode.firstChild!.firstChild!.value!, "Belgian Waffles")
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
		XCTAssertEqual(rootNode.lastChild!.name!, "food")
		
		XCTAssertNotNil(rootNode.lastChild!.lastChild)
		XCTAssertEqual(rootNode.lastChild!.lastChild!.name!, "calories")
		XCTAssertEqual(rootNode.lastChild!.lastChild!.value!, "950")
	}
	
	func testLastChildIsNil() {
		XCTAssertNil(rootNode.lastChild!.lastChild!.lastChild)
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
		XCTAssertEqual(rootNode.parent!.type, JiNodeType.Document)
	}
	
	func testLastChildNodeParentIsRootNode() {
		XCTAssertTrue(rootNode.lastChild?.parent == rootNode)
	}
	
	// MARK: - nextSibling
	func testFirstNextSibling() {
		let first = rootNode.firstChild!
		XCTAssertNotNil(first.nextSibling)
		XCTAssertEqual(first.nextSibling!.name!, "food")
	}
	
	func testSecondNextSibling() {
		let second = rootNode.children[1]
		XCTAssertNotNil(second.nextSibling)
		XCTAssertEqual(second.nextSibling!.name!, "not_food")
	}
	
	func testNextSiblingKeepTextNode() {
		let first = rootNode.firstChild!
		XCTAssertNotNil(first.nextSibling)
		XCTAssertEqual(first.nextSibling!.name!, "food")
		
		rootNode.keepTextNode = true
		let firstFoodNode = rootNode.children[1]
		XCTAssertEqual(firstFoodNode.keepTextNode, rootNode.keepTextNode)
		let textNode = firstFoodNode.nextSibling
		XCTAssertNotNil(textNode)
		XCTAssertEqual(textNode!.name!, "text")
		XCTAssertEqual(textNode!.content!, "some text\n\t")
	}
	
	// MARK: - previousSibling
	func testLastPreviousSibling() {
		let last = rootNode.lastChild!
		XCTAssertNotNil(last.previousSibling)
		XCTAssertEqual(last.previousSibling!.name!, "food")
	}
	
	func testLastThirdPreviousSibling() {
		let last = rootNode.lastChild!
		XCTAssertNotNil(last.previousSibling?.previousSibling?.previousSibling)
		XCTAssertEqual(last.previousSibling!.previousSibling!.previousSibling!.name!, "comment")
	}
	
	func testPreviousSiblingKeepTextNode() {
		let secondFood = rootNode.children[1]
		XCTAssertNotNil(secondFood)
		
		secondFood.keepTextNode = true
		let previouTextNode = secondFood.previousSibling
		XCTAssertNotNil(previouTextNode)
		XCTAssertEqual(previouTextNode!.keepTextNode, secondFood.keepTextNode)
		XCTAssertEqual(previouTextNode!.name!, "text")
		XCTAssertEqual(previouTextNode!.content!, "some text\n\t")
	}
	
	// MARK: - Content
	func testRawContent() {
		let node = rootNode.children[2].lastChild!
		var expectedString = "<test_content>  spaces before and tabs after\t\t</test_content>"
		XCTAssertEqual(node.rawContent!, expectedString)
		
		let not_foodNode = rootNode.children[2]
		expectedString = "<not_food description=\"for testing purpose\" price=\"infinite\">\n\t\t<name gender=\"Women's\">foo</name>\n\t\t<test_content>foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar</test_content>\n\t\t<test_content>  spaces before and tabs after\t\t</test_content>\n\t</not_food>"
		XCTAssertEqual(not_foodNode.rawContent!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertEqual(commentNode.rawContent!, "<!-- Dummy Comments 1 -->")
	}
	
	func testContent() {
		let node = rootNode.children[2].lastChild!
		var expectedString = "  spaces before and tabs after\t\t"
		XCTAssertEqual(node.content!, expectedString)
		
		let not_foodNode = rootNode.children[2]
		expectedString = "\n\t\tfoo\n\t\tfoo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar\n\t\t  spaces before and tabs after\t\t\n\t"
		XCTAssertEqual(not_foodNode.content!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertEqual(commentNode.content!, " Dummy Comments 1 ")
	}
	
	func testContentTextNode() {
		rootNode.keepTextNode = true
		let textNode = rootNode.children[2]
		XCTAssertEqual(textNode.content!, "some text\n\t")
	}
	
	// MARK: - Value
	func testValue() {
		var node = rootNode.children[2].lastChild!
		var expectedString = "  spaces before and tabs after\t\t"
		XCTAssertEqual(node.value!, expectedString)
		
		node = rootNode.children[2].children[1]
		expectedString = "foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar"
		XCTAssertEqual(node.value!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertNil(commentNode.value)
	}
	
//	func testValue() {
//		var node = rootNode.children[2].lastChild!
//		var expectedString = "spaces before and tabs after"
//		XCTAssertEqual(node.value!, expectedString)
//		
//		node = rootNode.children[2].children[1]
//		expectedString = "foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar"
//		XCTAssertEqual(node.value!, expectedString)
//		
//		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
//		XCTAssertNil(commentNode.value)
//	}
	
	func testValueTextNode() {
		rootNode.keepTextNode = true
		let textNode = rootNode.children[2]
		XCTAssertNil(textNode.value)
	}
	
	// MARK: - Attribute
	func testSubscriptAttribute() {
		let node = rootNode.children[2]
		XCTAssertNil(node["foo"])
		XCTAssertEqual(node["description"]!, "for testing purpose")
		XCTAssertEqual(node["price"]!, "infinite")
		
		XCTAssertEqual(node.firstChild!["gender"]!, "Women's")
	}
	
	func testAttributes() {
		XCTAssertEqual(rootNode.attributes.count, 0)
		
		let node = rootNode.children[2]
		XCTAssertEqual(node.attributes.count, 2)
		XCTAssertEqual(node.attributes["description"]!, "for testing purpose")
		XCTAssertEqual(node.attributes["price"]!, "infinite")
		
		XCTAssertEqual(node.firstChild!.attributes.count, 1)
		XCTAssertEqual(node.firstChild!.attributes["gender"]!, "Women's")
	}
	
	// MARK: - Search Children
	func testFirstChildWithName() {
		XCTAssertNil(rootNode.firstChildWithName("breakfast_menu"))
		XCTAssertEqual(rootNode.firstChildWithName("comment")!.content!, " Dummy Comments ")
	}
	
	func testChildrenWithName() {
		XCTAssertEqual(rootNode.childrenWithName("breakfast_menu").count, 0)
		XCTAssertEqual(rootNode.childrenWithName("comment").count, 2)
	}
	
	func testFirstChildWithAttributeValue() {
		XCTAssertEqual(rootNode.firstChildWithAttributeName("price", attributeValue: "infinite")!.name!, "not_food")
	}
	
	func testChildrenWithAttributeNameValue() {
		XCTAssertEqual(rootNode.childrenWithAttributeName("price", attributeValue: "infinite").count, 2)
	}
	
	// MARK: - Search Descendants
	func testFirstDescendantWithName() {
		XCTAssertNil(rootNode.firstDescendantWithName("breakfast_menu"))
		XCTAssertEqual(rootNode.firstDescendantWithName("test_content")!.content!, "foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar")
	}
	
	func testDescendantsWithName() {
		XCTAssertEqual(rootNode.descendantsWithName("breakfast_menu").count, 0)
		XCTAssertEqual(rootNode.descendantsWithName("test_content").count, 2)
	}
	
	func testFirstDescendantWithAttributeValue() {
		XCTAssertEqual(rootNode.firstDescendantWithAttributeName("gender", attributeValue: "Women's")!.name!, "name")
	}
	
	func testDescendantsWithAttributeNameValue() {
		XCTAssertEqual(rootNode.descendantsWithAttributeName("price", attributeValue: "infinite").count, 3)
	}
	
	// MARK: - Generator
	func testSequenceGenerator() {
		for (index, node) in rootNode!.enumerate() {
			if index == 2 {
				XCTAssertEqual(node.name!, "not_food")
			} else if index == 3 {
				XCTAssertEqual(node.name!, "empty_food")
			} else if index == 4 {
				XCTAssertEqual(node.name!, "comment")
			} else if index == 5 {
				XCTAssertEqual(node.name!, "comment")
				XCTAssertEqual(node.content!, " Dummy Comments 1 ")
			} else {
				XCTAssertEqual(node.name!, "food")
			}
		}
	}
	
	// MARK: - CustomStringConvertible
	func testCustomStringConvertible() {
		let node = rootNode.firstChild?.firstChildWithName("description")
		XCTAssertNotNil(node)
		XCTAssertEqual("\(node!)", node!.rawContent!)
	}
}
