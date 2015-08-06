//
//  ViewController.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-18.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Init with data
		let googleIndexData = NSData(contentsOfURL: NSURL(string: "http://www.google.com")!)
		if let googleIndexData = googleIndexData {
			let jiDoc = Ji(htmlData: googleIndexData)!
			let htmlNode = jiDoc.rootNode!
			println("html tagName: \(htmlNode.tagName)")
			
			let aNodes = jiDoc.xPath("//body//a")
			if let firstANode = aNodes?.first {
				println("first a node tagName: \(firstANode.name)")
				let href = firstANode["href"]
				println("first a node href: \(href)")
			}
		} else {
			println("google.com is inaccessible")
		}
		
		println()
		
		// Init with URL
		let jiAppleSupportDoc = Ji(htmlURL: NSURL(string: "http://www.apple.com/support")!)
		let titleNode = jiAppleSupportDoc?.xPath("//head/title")?.first
		println("title: \(titleNode?.content)")
		
		println()
		
		// Init with String
		let xmlString = "<?xml version='1.0' encoding='UTF-8'?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>"
		let xmlDoc = Ji(xmlString: xmlString)
		let bodyNode = xmlDoc?.rootNode?.firstChildWithName("body")
		println("body: \(bodyNode?.content)")
	}
}
