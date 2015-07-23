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
		var xmlFileURL = NSURL(string: "sample-menu.xml", relativeToURL: NSBundle(forClass: JiTests.self).resourceURL)!
		sampleMenuXMLDocument = JiDocument(xmlURL: xmlFileURL)
    }
	
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
