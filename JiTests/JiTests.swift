//
//  JiTests.swift
//  JiTests
//
//  Created by Honghao Zhang on 2015-07-18.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import XCTest
import Ji

class JiTests: XCTestCase {
	var sampleMenuXMLDocument: JiDocument!
	
    override func setUp() {
        super.setUp()
		let xmlFileURL = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: JiTests.self).resourceURL)!
//		var xmlFileURL = NSURL(string: "http://www.w3schools.com/xml/simple.xml")!
		let xmlData = NSData(contentsOfURL: xmlFileURL)
//		sampleMenuXMLDocument = JiDocument(data: xmlData, isXML: true)
		sampleMenuXMLDocument = JiDocument(contentsOfURL: xmlFileURL, isXML: true)
    }
	
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

	func testDocumentsInitialized() {
		XCTAssertNotNil(sampleMenuXMLDocument)
	}
}
