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
	var jiDocument: JiDocument!
	
    override func setUp() {
        super.setUp()
		let xmlFileURL = NSURL(string: "feed.rss", relativeToURL: NSBundle(forClass: JiTests.self).resourceURL)!
		jiDocument = JiDocument(xmlURL: xmlFileURL)
    }
	
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
