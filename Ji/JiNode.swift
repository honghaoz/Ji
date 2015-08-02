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
	public let document: Ji
	public let type: JiNodeType
	
	private var _keepTextNodePrevious = false
	public var keepTextNode = false
	
	init(xmlNode: xmlNodePtr, jiDocument: Ji, keepTextNode: Bool = false) {
		self.xmlNode = xmlNode
		document = jiDocument
		type = JiNodeType(rawValue: Int(xmlNode.memory.type.value))!
		self.keepTextNode = keepTextNode
	}
	
	public var tagName: String? { return name }
	
	public lazy var name: String? = {
		return String.fromXmlChar(self.xmlNode.memory.name)
	}()
	
	private var _children: [JiNode] = []
	private var _childrenHasBeenCalculated = false
	public var children: [JiNode] {
		if _childrenHasBeenCalculated && keepTextNode == _keepTextNodePrevious {
			return _children
		} else {
			_children = [JiNode]()
			
			for var childNodePointer = xmlNode.memory.children;
				childNodePointer != nil;
				childNodePointer = childNodePointer.memory.next
			{
				if keepTextNode || xmlNodeIsText(childNodePointer) == 0 {
					let childNode = JiNode(xmlNode: childNodePointer, jiDocument: document, keepTextNode: keepTextNode)
					_children.append(childNode)
				}
			}
			_childrenHasBeenCalculated = true
			_keepTextNodePrevious = keepTextNode
			return _children
		}
	}
	
	public var firstChild: JiNode? {
		var first = xmlNode.memory.children
		if first == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: first, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(first) != 0 {
				first = first.memory.next
				if first == nil { return nil }
			}
			return JiNode(xmlNode: first, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	public var lastChild: JiNode? {
		var last = xmlNode.memory.last
		if last == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: last, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(last) != 0 {
				last = last.memory.prev
				if last == nil { return nil }
			}
			return JiNode(xmlNode: last, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	public var hasChildren: Bool {
		return firstChild != nil
	}
	
	public lazy var parent: JiNode? = {
		if self.xmlNode.memory.parent == nil { return nil }
		return JiNode(xmlNode: self.xmlNode.memory.parent, jiDocument: self.document)
	}()
	
	public var nextSibling: JiNode? {
		var next = xmlNode.memory.next
		if next == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: next, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(next) != 0 {
				next = next.memory.next
				if next == nil { return nil }
			}
			return JiNode(xmlNode: next, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
	public var previousSibling: JiNode? {
		var prev = xmlNode.memory.prev
		if prev == nil { return nil }
		if keepTextNode {
			return JiNode(xmlNode: prev, jiDocument: document, keepTextNode: keepTextNode)
		} else {
			while xmlNodeIsText(prev) != 0 {
				prev = prev.memory.prev
				if prev == nil { return nil }
			}
			return JiNode(xmlNode: prev, jiDocument: document, keepTextNode: keepTextNode)
		}
	}
	
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
			let jiNode = JiNode(xmlNode: nodeSet.memory.nodeTab[i], jiDocument: self.document, keepTextNode: keepTextNode)
			resultNodes.append(jiNode)
		}
		
		xmlXPathFreeObject(xPathObject)
		
		return resultNodes
	}
	
	// MARK: - Handy search methods: Children
	public func firstChildWithName(name: String) -> JiNode? {
		var node = firstChild
		while (node != nil) {
			if node!.name == name {
				return node
			}
			node = node?.nextSibling
		}
		return nil
	}
	
	public func childrenWithName(name: String) -> [JiNode] {
		return children.filter { $0.name == name }
	}
	
	public func firstChildWithAttributeName(attributeName: String, attributeValue: String) -> JiNode? {
		var node = firstChild
		while (node != nil) {
			if let value = node![attributeName] where value == attributeValue {
				return node
			}
			node = node?.nextSibling
		}
		return nil
	}
	
	public func childrenWithAttributeName(attributeName: String, attributeValue: String) -> [JiNode] {
		return children.filter { $0.attributes[attributeName] == attributeValue }
	}
	
	// MARK: - Handy search methods: Descendants
	public func firstDescendantWithName(name: String) -> JiNode? {
		return firstDescendantWithName(name, node: self)
	}
	
	private func firstDescendantWithName(name: String, node: JiNode) -> JiNode? {
		if !node.hasChildren {
			return nil
		}
		
		for child in node {
			if child.name == name {
				return child
			}
			if let nodeFound = firstDescendantWithName(name, node: child) {
				return nodeFound
			}
		}
		return nil
	}
	
	public func descendantsWithName(name: String) -> [JiNode] {
		return descendantsWithName(name, node: self)
	}
	
	private func descendantsWithName(name: String, node: JiNode) -> [JiNode] {
		if !node.hasChildren {
			return []
		}
		
		var results = [JiNode]()
		for child in node {
			if child.name == name {
				results.append(child)
			}
			results.extend(descendantsWithName(name, node: child))
		}
		return results
	}
	
	public func firstDescendantWithAttributeName(attributeName: String, attributeValue: String) -> JiNode? {
		return firstDescendantWithAttributeName(attributeName, attributeValue: attributeValue, node: self)
	}
	
	private func firstDescendantWithAttributeName(attributeName: String, attributeValue: String, node: JiNode) -> JiNode? {
		if !node.hasChildren {
			return nil
		}
		
		for child in node {
			if child[attributeName] == attributeValue {
				return child
			}
			if let nodeFound = firstDescendantWithAttributeName(attributeName, attributeValue: attributeValue, node: child) {
				return nodeFound
			}
		}
		return nil
	}
	
	public func descendantsWithAttributeName(attributeName: String, attributeValue: String) -> [JiNode] {
		return descendantsWithAttributeName(attributeName, attributeValue: attributeValue, node: self)
	}
	
	private func descendantsWithAttributeName(attributeName: String, attributeValue: String, node: JiNode) -> [JiNode] {
		if !node.hasChildren {
			return []
		}
		
		var results = [JiNode]()
		for child in node {
			if child[attributeName] == attributeValue {
				results.append(child)
			}
			results.extend(descendantsWithAttributeName(attributeName, attributeValue: attributeValue, node: child))
		}
		return results
	}
}

// MARK: - Equatable
extension JiNode: Equatable { }
public func ==(lhs: JiNode, rhs: JiNode) -> Bool {
	if lhs.document == rhs.document && lhs.xmlNode != nil && rhs.xmlNode != nil {
		return xmlXPathCmpNodes(lhs.xmlNode, rhs.xmlNode) == 0
	}
	return false
}

// MARK: - SequenceType
extension JiNode: SequenceType {
	public func generate() -> JiNodeGenerator {
		return JiNodeGenerator(node: self)
	}
}

public class JiNodeGenerator: GeneratorType {
	private var node: JiNode?
	private var started = false
	public init(node: JiNode) {
		self.node = node
	}
	
	public func next() -> JiNode? {
		if !started {
			node = node?.firstChild
			started = true
		} else {
			node = node?.nextSibling
		}
		return node
	}
}
