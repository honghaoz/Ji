//
//  JiHTMLTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
import Ji

class JiHTMLTests: XCTestCase {
	var doc: Ji!
	
	override func setUp() {
		super.setUp()
		let testBundle = NSBundle(forClass: JiHTMLTests.self)
		let testFileURL = testBundle.URLForResource("index", withExtension: "html", subdirectory: nil)
		let data = NSData(contentsOfURL: testFileURL!)
		doc = Ji(HTMLData: data!)
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInitializesWithHTMLData() {
		XCTAssertNotNil(doc.data)
	}
	
	//  doc.search("//p[@class='posted']")
	func testSearchesWithXPath() {
		var results = doc.searchWithXPathQuery("//a[@class='sponsor']")
		XCTAssertEqual(results.count, 2)
	}
	
	func testFindsFirstElementAtXPath() {
		let first = doc.peekAtSearchWithXPathQuery("//a[@class='sponsor']")
		
		XCTAssertEqual(first!.content!, "RailsMachine")
		XCTAssertEqual(first!.tagName!, "a")
	}
}
