//
//  JiNode.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public enum JiNodeType: Int {
	case Element = 1
	case Attribute = 2
	case Text = 3
	case CDataSection = 4
	case EntityRef = 5
	case Entity = 6
	case Pi = 7
	case Comment = 8
	case Document = 9
	case DocumentType = 10
	case DocumentFrag = 11
	case Notation = 12
	case HtmlDocument = 13
	case DTD = 14
	case ElementDecl = 15
	case AttributeDecl = 16
	case EntityDecl = 17
	case NamespaceDecl = 18
	case XIncludeStart = 19
	case XIncludeEnd = 20
	case DocbDocument = 21
}

public class JiNode {
	public let xmlNode: xmlNodePtr
	public let document: JiDocument
	public let type: JiNodeType
	
	public var keepTextNode: Bool = false
	// TODO: Change lazy properties
	
	init(xmlNode: xmlNodePtr, jiDocument: JiDocument) {
		self.xmlNode = xmlNode
		document = jiDocument
		type = JiNodeType(rawValue: Int(xmlNode.memory.type.value))!
	}
	
	public var tagName: String? { return name }
	
	public lazy var name: String? = {
		return String.fromXmlChar(self.xmlNode.memory.name)
	}()
	
	public lazy var children: [JiNode] = {
		var resultChildren = [JiNode]()
		
		for var childNodePointer = self.xmlNode.memory.children;
			childNodePointer != nil;
			childNodePointer = childNodePointer.memory.next
		{
			if self.keepTextNode || xmlNodeIsText(childNodePointer) == 0 {
				let childNode = JiNode(xmlNode: childNodePointer, jiDocument: self.document)
				resultChildren.append(childNode)
			}
		}
		
		return resultChildren
	}()
	
	public lazy var firstChild: JiNode? = {
		var first = self.xmlNode.memory.children
		if first == nil { return nil }
		if self.keepTextNode {
			return JiNode(xmlNode: first, jiDocument: self.document)
		} else {
			while xmlNodeIsText(first) != 0 {
				first = first.memory.next
				if first == nil { return nil }
			}
			return JiNode(xmlNode: first, jiDocument: self.document)
		}
	}()
	
	public lazy var lastChild: JiNode? = {
		var last = self.xmlNode.memory.last
		if last == nil { return nil }
		if self.keepTextNode {
			return JiNode(xmlNode: last, jiDocument: self.document)
		} else {
			while xmlNodeIsText(last) != 0 {
				last = last.memory.prev
				if last == nil { return nil }
			}
			return JiNode(xmlNode: last, jiDocument: self.document)
		}
	}()
	
	public lazy var parent: JiNode? = {
		if self.xmlNode.memory.parent == nil { return nil }
		return JiNode(xmlNode: self.xmlNode.memory.parent, jiDocument: self.document)
	}()
	
	public lazy var nextSibling: JiNode? = {
		var next = self.xmlNode.memory.next
		if next == nil { return nil }
		if self.keepTextNode {
			return JiNode(xmlNode: next, jiDocument: self.document)
		} else {
			while xmlNodeIsText(next) != 0 {
				next = next.memory.next
				if next == nil { return nil }
			}
			return JiNode(xmlNode: next, jiDocument: self.document)
		}
	}()
	
	public lazy var previousSibling: JiNode? = {
		var prev = self.xmlNode.memory.prev
		if prev == nil { return nil }
		if self.keepTextNode {
			return JiNode(xmlNode: prev, jiDocument: self.document)
		} else {
			while xmlNodeIsText(prev) != 0 {
				prev = prev.memory.prev
				if prev == nil { return nil }
			}
			return JiNode(xmlNode: prev, jiDocument: self.document)
		}
	}()
	
	public lazy var rawContent: String? = {
		let contentChars = xmlNodeGetContent(self.xmlNode)
		if contentChars == nil { return nil }
		let contentString = String.fromXmlChar(contentChars)
		free(contentChars)
		return contentString
	}()
	
	public lazy var content: String? = {
		let contentChars = xmlNodeGetContent(self.xmlNode)
		if contentChars == nil { return nil }
		let contentString = String.fromXmlChar(contentChars)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		free(contentChars)
		return contentString
	}()
	
	public lazy var rawValue: String? = {
		let valueChars = xmlNodeListGetString(self.document.xmlDoc, self.xmlNode.memory.children, 1)
		if valueChars == nil { return nil }
		let valueString = String.fromXmlChar(valueChars)
		free(valueChars)
		return valueString
	}()
	
	public lazy var value: String? = {
		let valueChars = xmlNodeListGetString(self.document.xmlDoc, self.xmlNode.memory.children, 1)
		if valueChars == nil { return nil }
		let valueString = String.fromXmlChar(valueChars)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		free(valueChars)
		return valueString
	}()
	
	/**
	Get attribute with key
	
	:param: key attribute key string
	
	:returns: attribute
	*/
	public subscript(key: String) -> String? {
		get {
			for var attribute: xmlAttrPtr = self.xmlNode.memory.properties; attribute != nil; attribute = attribute.memory.next {
				if key == String.fromXmlChar(attribute.memory.name) {
					let contentChars = xmlNodeGetContent(attribute.memory.children)
					if contentChars == nil { return nil }
					let contentString = String.fromXmlChar(contentChars)
					free(contentChars)
					return contentString
				}
			}
			return nil
		}
	}
	
	public lazy var attributes: [String: String] = {
		var result = [String: String]()
		for var attribute: xmlAttrPtr = self.xmlNode.memory.properties;
			attribute != nil;
			attribute = attribute.memory.next
		{
			let key = String.fromXmlChar(attribute.memory.name)
			assert(key != nil, "key doesn't exist")
			let valueChars = xmlNodeGetContent(attribute.memory.children)
			var value: String? = ""
			if valueChars != nil {
				value = String.fromXmlChar(valueChars)
				assert(value != nil, "value doesn't exist")
			}
			free(valueChars)
			
			result[key!] = value!
		}
		return result
	}()
	
	public func searchWithXPathQuery(xPathQuery: String) -> [JiNode]? {
		let xPathContext = xmlXPathNewContext(self.document.xmlDoc)
		if xPathContext == nil {
			println("Unable to create XPath context.")
			return nil
		}
		
		xPathContext.memory.node = self.xmlNode
		
		let xPathObject = xmlXPathEvalExpression(UnsafePointer<xmlChar>(xPathQuery.cStringUsingEncoding(NSUTF8StringEncoding)!), xPathContext)
		xmlXPathFreeContext(xPathContext)
		if xPathObject == nil {
			println("Unable to evaluate XPath.")
			return nil;
		}
		
		let nodeSet = xPathObject.memory.nodesetval
		if nodeSet == nil || nodeSet.memory.nodeNr == 0 || nodeSet.memory.nodeTab == nil {
			println("NodeSet is nil.")
			return nil
		}
		
		var resultNodes = [JiNode]()
		for i in 0 ..< Int(nodeSet.memory.nodeNr) {
			let jiNode = JiNode(xmlNode: nodeSet.memory.nodeTab[i], jiDocument: self.document)
			resultNodes.append(jiNode)
		}
		
		xmlXPathFreeObject(xPathObject)
		
		return resultNodes
	}
}

extension JiNode: Equatable { }
public func ==(lhs: JiNode, rhs: JiNode) -> Bool {
	if lhs.document == rhs.document && lhs.xmlNode != nil && rhs.xmlNode != nil {
		return xmlXPathCmpNodes(lhs.xmlNode, rhs.xmlNode) == 0
	}
	return false
}
