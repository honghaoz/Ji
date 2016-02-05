//
//  JiTests.swift
//  JiTests
//
//  Created by Honghao Zhang on 2015-07-18.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
@testable import Ji

class JiTests: XCTestCase {
    override func setUp() {
        super.setUp()
		// Setup here
    }
	
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }
	
	// MARK: - Init
	func testInitWithLocalXMLURLSucceed() {
		let url = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: self.dynamicType).resourceURL)!
		let document = Ji(xmlURL: url)
		XCTAssertNotNil(document)
	}

	func testInitWithRemoteXMLURLSucceed() {
		let xmlFileURL = NSURL(string: "http://www.w3schools.com/xml/simple.xml")
		if let xmlFileURL = xmlFileURL {
			let ji = Ji(xmlURL: xmlFileURL)
			XCTAssertNotNil(ji)
		} else {
			NSLog("WARNING: simple.xml is not found!")
		}
	}
	
	func testInitWithInvalidURLFailed() {
		let url = NSURL(string: "dummyURL")!
		let document = Ji(xmlURL: url)
		XCTAssertNil(document)
	}
	
	// MARK: Root Node
	func testRootNodeNotNil() {
		let url = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: self.dynamicType).resourceURL)!
		let document = Ji(xmlURL: url)
		XCTAssertNotNil(document!.rootNode)
	}
	
	// MARK: - Printable
	func testPrintable() {
		let url = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: self.dynamicType).resourceURL)!
		let document = Ji(xmlURL: url)
		XCTAssertNotNil(document)
		XCTAssertEqual("\(document!)", document!.rootNode!.rawContent!)
	}
}
