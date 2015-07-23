//
//  JiDocumentTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-22.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
import Ji

class JiDocumentTests: JiTests {
	func testInitFailed() {
		let url = NSURL(string: "dummyURL")!
		let document = JiDocument(xmlURL: url)
		XCTAssertNil(document)
	}
	
	func testInitSucceed() {
		let url = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: JiTests.self).resourceURL)!
		let document = JiDocument(xmlURL: url)
		XCTAssertNotNil(document)
	}
	
	func testRootNodeNotNil() {
		let url = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: JiTests.self).resourceURL)!
		let document = JiDocument(xmlURL: url)
		XCTAssertNotNil(document!.rootNode)
	}
}
