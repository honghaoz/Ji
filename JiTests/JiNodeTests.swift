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
		rootNode = jiDocument.rootNode
	}
	
	override func tearDown() {
		// Put teardown code here.
		super.tearDown()
	}
	
	func testInitialization() {
		XCTAssertNotNil(rootNode)
	}
	
	func testNodeName() {
		XCTAssertEqual(rootNode.name!, "rss")
	}
}
