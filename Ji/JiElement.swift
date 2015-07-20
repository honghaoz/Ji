//
//  JiElement.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-19.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

let JiNodeContentKey = "nodeContent"
let JiNodeNameKey = "nodeName"
let JiNodeChildrenKey = "nodeChildArray"
let JiNodeAttributeArrayKey = "nodeAttributeArray"
let JiNodeAttributeNameKey = "attributeName"

let JiTextNodeName = "text"

public class JiElement {
	public var raw: String? { return node!["raw"] as? String }
	public var content: String? { return node![JiNodeContentKey] as? String }
	public var tagName: String? { return node![JiNodeNameKey] as? String }
	public var attributes: [String: Any]? {
		var translatedAttributes = [String: Any]()
		for attributeDict in node![JiNodeAttributeArrayKey] as! [[String: Any]?] {
			if let nodeContent = attributeDict![JiNodeContentKey], let attributeName = attributeDict![JiNodeAttributeNameKey] as? String {
				translatedAttributes[attributeName] = nodeContent
			}
		}
		
		return translatedAttributes
	}
	
	public var children: [JiElement] {
		var children = [JiElement]()
		for child in node![JiNodeChildrenKey] as! [[String: Any]?] {
			let element = JiElement.elementWithNode(child, isXML: isXML, withEncoding: encoding)
			element.parent = self
			children.append(element)
		}
		
		return children
	}
	
	public var firstChild: JiElement? { return children.first }
	
	private(set) public weak var parent: JiElement?
	private var node: [String: Any]?
	private var isXML = false
	private var encoding: String?
	
	var description: String { return node!.description }
	
	init(node: [String: Any]?, isXML: Bool, withEncoding encoding: String?) {
		self.isXML = isXML
		self.node = node
		self.encoding = encoding
	}
	
	public class func elementWithNode(node: [String: Any]?, isXML: Bool, withEncoding encoding: String?) -> JiElement {
		return self.init(node: node, isXML: isXML, withEncoding: encoding)
	}
	
	// MARK: -
	public subscript(key: String) -> String? {
		get {
			return attributes![key] as? String
		}
	}
	
	public func hasChildren() -> Bool {
		if let _ = node![JiNodeChildrenKey] {
			return true
		} else {
			return false
		}
	}
	
	public func isTextNode() -> Bool {
		// we must distinguish between real text nodes and standard nodes with tha name "text" (<text>)
		// real text nodes must have content
		if let tagName = tagName where tagName == JiTextNodeName && content != nil {
			return true
		} else {
			return false
		}
	}
	
	public func childrenWithTagName(tagName: String) -> [JiElement] {
		var matches = [JiElement]()
		for child in children {
			if let childTagName = child.tagName where childTagName == tagName {
				matches.append(child)
			}
		}
		
		return matches
	}
	
	public func firstChildWithTagName(tagName: String) -> JiElement? {
		for child in children {
			if let childTagName = child.tagName where childTagName == tagName {
				return child
			}
		}
		
		return nil
	}
	
	public func childrenWithClassName(className: String) -> [JiElement] {
		var matches = [JiElement]()
		for child in children {
			if let childClassName = child["class"] where childClassName == className {
				matches.append(child)
			}
		}
		
		return matches
	}
	
	func firstChildWithClassName(className: String) -> JiElement? {
		for child in children {
			if let childClassName = child["class"] where childClassName == className {
				return child
			}
		}
		
		return nil
	}
	
	public func firstTextChild() -> JiElement? {
		for child in children {
			if child.isTextNode() {
				return child
			}
		}
		
		return firstChildWithTagName(JiTextNodeName)
	}
	
	public func text() -> String? {
		return firstTextChild()?.content
	}
	
	// Returns all elements at xPath.
	public func searchWithXPathQuery(xPathOrCSS: String) -> [JiElement] {
		var data = raw!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		
		var detailNodes: [[String: Any]?]? = nil
		if isXML {
			detailNodes = performXMLXPathQueryWithEncoding(data!, xPathOrCSS, encoding)
		} else {
			detailNodes = performHTMLXPathQueryWithEncoding(data!, xPathOrCSS, encoding)
		}
		
		var elements = [JiElement]()
		if let detailNodes = detailNodes {
			for newNode in detailNodes {
				elements.append(JiElement.elementWithNode(newNode, isXML: isXML, withEncoding: encoding))
			}
		}
		
		return elements
	}
	
	public func objectForKeyedSubscript(key: String!) -> AnyObject! {
		return self[key]
	}
}
