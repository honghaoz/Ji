//
//  JiDocument.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-21.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public class JiDocument {
	public let xmlDoc: xmlDocPtr
	
	private var _rootNode: JiNode?
	public var rootNode: JiNode? {
		return nil
	}
	
	public init(xmlURL: NSURL) {
		xmlDoc = xmlParseFile(xmlURL.fileSystemRepresentation)
	}
	
	deinit {
		xmlFreeDoc(xmlDoc)
	}
}