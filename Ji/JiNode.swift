//
//  JiNode.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public class JiNode {
	public var document: JiDocument
	public let xmlNode: xmlNodePtr
	
	init(xmlNode: xmlNodePtr, jiDocument: JiDocument) {
		self.xmlNode = xmlNode
		document = jiDocument
	}
	
	public lazy var name: String? = {
		return String.fromXmlChar(self.xmlNode.memory.name)
	}()
	
	public lazy var children: [JiNode] = {
		var resultChildren = [JiNode]()
		
		for var childNodePointer = self.xmlNode.memory.children;
			childNodePointer != nil;
			childNodePointer = childNodePointer.memory.next
		{
//			if xmlNodeIsText(childNodePointer) == 0 {
				let childNode = JiNode(xmlNode: childNodePointer, jiDocument: self.document)
				resultChildren.append(childNode)
//			}
		}
		
		return resultChildren
	}()
	
	public lazy var lastChild: JiNode? = {
		self.xmlNode.memory.last == nil ? nil : JiNode(xmlNode: self.xmlNode.memory.last, jiDocument: self.document)
	}()
	
	public lazy var parent: JiNode? = {
		self.xmlNode.memory.parent == nil ? nil : JiNode(xmlNode: self.xmlNode.memory.parent, jiDocument: self.document)
	}()
	
	public lazy var nextSibling: JiNode? = {
		self.xmlNode.memory.next == nil ? nil : JiNode(xmlNode: self.xmlNode.memory.next, jiDocument: self.document)
	}()
	
	public lazy var previousSibling: JiNode? = {
		self.xmlNode.memory.next == nil ? nil : JiNode(xmlNode: self.xmlNode.memory.prev, jiDocument: self.document)
	}()
	
	public lazy var content: String? = {
		String.fromXmlChar(self.xmlNode.memory.content)
	}()
	
	public lazy var value: String? = {
		let textValue = xmlNodeListGetString(self.document.xmlDoc, self.xmlNode.memory.children, 1)
		if (textValue != nil) {
			let nodeString = String.fromXmlChar(textValue)
			free(textValue)
			return nodeString
		} else {
			return nil
		}
	}()
}
