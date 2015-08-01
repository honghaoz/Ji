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
		
		let googleIndexData = NSData(contentsOfURL: NSURL(string: "https://www.google.com")!)!
		let jiGoogleIndexDoc = Ji(htmlData: googleIndexData)
	}
}
