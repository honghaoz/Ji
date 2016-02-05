//
//  htmlXPathTests.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import XCTest
@testable import Ji

class htmlXPathTests: XCTestCase {
	var sampleHTML: Ji!
	
	override func setUp() {
		super.setUp()
		let testBundle = NSBundle(forClass: htmlXPathTests.self)
		let testFileURL = testBundle.URLForResource("index", withExtension: "html", subdirectory: nil)
		let data = NSData(contentsOfURL: testFileURL!)
		sampleHTML = Ji(htmlData: data!)
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInitializationSucceed() {
		XCTAssertNotNil(sampleHTML.data)
		XCTAssertNotNil(sampleHTML.rootNode)
	}
	
	// $x("//a[@class='gh-tab-link']")
	func testSearchesWithXPath() {
		var results = sampleHTML.rootNode?.xPath("//a[@class='gh-tab-link']")
		XCTAssertEqual(results!.count, 8)
		
		XCTAssertEqual(results![2].name!, "a")
		XCTAssertEqual(results![2]["href"]!, "/mac/")
		XCTAssertEqual(results![2].content!, "Mac")
	}
	
	// $x("//a[@class='gh-tab-link'][@href='/mac/']")
	func testSearchesWithXPath1() {
		let results = sampleHTML.rootNode?.xPath("//a[@class='gh-tab-link'][@href='/mac/']")
		XCTAssertEqual(results!.count, 1)
		
		XCTAssertEqual(results!.first!.name!, "a")
		XCTAssertEqual(results!.first!["href"]!, "/mac/")
		XCTAssertEqual(results!.first!.content!, "Mac")
	}
	
	// $x("//a[@class='gh-tab-link'][@href='/mac/']//span")
	func testSearchesWithXPath2() {
		let results = sampleHTML.rootNode?.xPath("//a[@class='gh-tab-link'][@href='/mac/']//span")
		XCTAssertEqual(results!.count, 2)
		
		XCTAssertEqual(results!.first!.name!, "span")
		XCTAssertEqual(results!.first!.children.count, 1)
		XCTAssertEqual(results!.last!.children.count, 0)
	}
	
	// $x("//a[@class='gh-tab-link'][@href='/mac/']/span")
	func testSearchesWithXPath3() {
		let results = sampleHTML.rootNode?.xPath("//a[@class='gh-tab-link'][@href='/mac/']/span")
		XCTAssertEqual(results!.count, 1)
		
		XCTAssertEqual(results!.first!.name!, "span")
		XCTAssertEqual(results!.first!.children.count, 1)
	}
	
	// $x("//div[starts-with(@class,'gh')]")
	func testStartsWith() {
		let results = sampleHTML.xPath("//div[starts-with(@class,'gh')]")
		XCTAssertEqual(results!.count, 5)
	}
	
	// $x("//script[starts-with(@type,'te')]")
	func testStartsWith1() {
		let results = sampleHTML.xPath("//script[starts-with(@type,'te')] | //div[starts-with(@class,'gh')]")
		XCTAssertEqual(results!.count, 17 + 5)
	}
}
