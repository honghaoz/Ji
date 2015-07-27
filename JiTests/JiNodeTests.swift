//
//  JiNodeTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-22.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
import Ji

class JiNodeTests: JiTests {
	var rootNode: JiNode!
	override func setUp() {
		super.setUp()
		rootNode = sampleMenuXMLDocument.rootNode
	}
	
	override func tearDown() {
		// Put teardown code here.
		super.tearDown()
	}
	
	func testInitialization() {
		XCTAssertNotNil(rootNode)
	}
	
	func testNodeName() {
		XCTAssertEqual(rootNode.name!, "breakfast_menu")
	}
	
	func testNodeTagName() {
		XCTAssertEqual(rootNode.tagName!, "breakfast_menu")
	}
	
	func testChildrenCount() {
		XCTAssertEqual(rootNode.children.count, 9)
	}
	
	func testChildrenCountIncludeTextNode() {
		rootNode.keepTextNode = true
		XCTAssertEqual(rootNode.children.count, 19)
		
//		rootNode.keepTextNode = false
//		XCTAssertEqual(rootNode.children.count, 9)
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
	
	func testCertainChildrenValueMatched() {
		XCTAssertEqual(rootNode.children[1].children[2].value!, "Light Belgian waffles covered with strawberries and whipped cream")
		XCTAssertEqual(rootNode.children[1].children[1].value!, "$7.95")
		
		XCTAssertEqual(rootNode.children[2].children[0].value!, "foo")
		XCTAssertEqual(rootNode.children[2].children[1].name!, "test_content")
	}
	
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
	
	func testRootNodeParentTypeIsDoc() {
		XCTAssertEqual(rootNode.parent!.type, JiNodeType.Document)
	}
	
	func testLastChildNodeParentIsRootNode() {
		XCTAssertTrue(rootNode.lastChild?.parent == rootNode)
	}
	
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
	
	func testRawContent() {
		let node = rootNode.children[2].lastChild!
		var expectedString = "  spaces before and tabs after\t\t"
		XCTAssertEqual(node.rawContent!, expectedString)
		
		let not_foodNode = rootNode.children[2]
		expectedString = "\n\t\tfoo\n\t\tfoo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar\n\t\t  spaces before and tabs after\t\t\n\t"
		XCTAssertEqual(not_foodNode.rawContent!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertEqual(commentNode.rawContent!, " Dummy Comments 1 ")
	}
	
	func testContent() {
		let node = rootNode.children[2].lastChild!
		var expectedString = "spaces before and tabs after"
		XCTAssertEqual(node.content!, expectedString)
		
		let not_foodNode = rootNode.children[2]
		expectedString = "foo\n\t\tfoo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar\n\t\t  spaces before and tabs after"
		XCTAssertEqual(not_foodNode.content!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertEqual(commentNode.content!, "Dummy Comments 1")
	}
	
	func testRawValue() {
		var node = rootNode.children[2].lastChild!
		var expectedString = "  spaces before and tabs after\t\t"
		XCTAssertEqual(node.rawValue!, expectedString)
		
		node = rootNode.children[2].children[1]
		expectedString = "foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar"
		XCTAssertEqual(node.rawValue!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertNil(commentNode.rawValue)
	}
	
	func testValue() {
		var node = rootNode.children[2].lastChild!
		var expectedString = "spaces before and tabs after"
		XCTAssertEqual(node.value!, expectedString)
		
		node = rootNode.children[2].children[1]
		expectedString = "foo_following_Tab\tfooo_following_Endline_then_three_Tabs\n\t\t\tbar"
		XCTAssertEqual(node.value!, expectedString)
		
		let commentNode = rootNode.lastChild!.previousSibling!.previousSibling!.previousSibling!
		XCTAssertNil(commentNode.value)
	}
	
	func testSubscriptAttribute() {
		var node = rootNode.children[2]
		XCTAssertNil(node["foo"])
		XCTAssertEqual(node["description"]!, "for testing purpose")
		XCTAssertEqual(node["price"]!, "infinite")
		
		XCTAssertEqual(node.firstChild!["gender"]!, "Women's")
	}
	
	func testAttributes() {
		XCTAssertEqual(rootNode.attributes.count, 0)
		
		var node = rootNode.children[2]
		XCTAssertEqual(node.attributes.count, 2)
		XCTAssertEqual(node.attributes["description"]!, "for testing purpose")
		XCTAssertEqual(node.attributes["price"]!, "infinite")
		
		XCTAssertEqual(node.firstChild!.attributes.count, 1)
		XCTAssertEqual(node.firstChild!.attributes["gender"]!, "Women's")
	}
}
