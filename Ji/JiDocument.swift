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
		
	public init?(xmlURL: NSURL) {
		xmlDoc = xmlParseFile(xmlURL.fileSystemRepresentation)
		if xmlDoc == nil {
			return nil
		}
	}
	
	deinit {
		xmlFreeDoc(xmlDoc)
	}
	
	public lazy var rootNode: JiNode? = {
		let rootNodePointer = xmlDocGetRootElement(self.xmlDoc)
		if rootNodePointer == nil {
			return nil
		} else {
			return JiNode(xmlNode: rootNodePointer, jiDocument: self)
		}
	}()
}

extension JiDocument: Equatable { }
public func ==(lhs: JiDocument, rhs: JiDocument) -> Bool {
	return lhs.xmlDoc == rhs.xmlDoc
}
