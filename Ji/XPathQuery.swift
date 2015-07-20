//
//  libXMLDoc.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-18.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

func dictionaryForNode(currentNode: xmlNodePtr, inout parentResult: [String: Any]?, parentContent: Bool) -> [String: Any]? {
	var resultForNode = [String: Any]()
	
	if let currentNodeContent = String.fromXmlChar(currentNode.memory.name) {
		resultForNode["nodeName"] = currentNodeContent
	}
	
	let nodeContent = xmlNodeGetContent(currentNode)
	if nodeContent != nil {
		let currentNodeContent = String.fromXmlChar(nodeContent)
		
		if let nodeName = resultForNode["nodeName"] as? String where nodeName == "text" && parentResult != nil {
			if parentContent {
				let charactersToTrim = NSCharacterSet.whitespaceAndNewlineCharacterSet()
				// Note: possible problem, currentNodeContent can be nil
				parentResult!["nodeContent"] = currentNodeContent?.stringByTrimmingCharactersInSet(charactersToTrim)
				return nil
			}
			
			if let currentNodeContent = currentNodeContent {
				resultForNode["nodeContent"] = currentNodeContent
			}
			return resultForNode
		} else {
			resultForNode["nodeContent"] = currentNodeContent
		}
		
		// Replaced: xmlFree(nodeContent)
		free(nodeContent)
	}
	
	var attribute = currentNode.memory.properties
	if attribute != nil {
		var attributeArray = [[String: Any]?]()
		while attribute != nil {
			var attributeDictionary = [String: Any]?()
			let attributeName = String.fromXmlChar(attribute.memory.name)
			
			if let attributeName = attributeName {
				attributeDictionary?["attributeName"] = attributeName
			}
			
			if attribute.memory.children != nil {
				let childDictionary = dictionaryForNode(attribute.memory.children as xmlNodePtr, &attributeDictionary, true)
				if let childDictionary = childDictionary {
					attributeDictionary?["attributeContent"] = childDictionary
				}
			}
			
			if attributeDictionary?.count > 0 {
				attributeArray.append(attributeDictionary)
			}
			attribute = attribute.memory.next
		}
		
		if attributeArray.count > 0 {
			resultForNode["nodeAttributeArray"] = attributeArray
		}
	}
	
	var childNode = currentNode.memory.children
	if childNode != nil {
		var childContentArray = [[String: Any]?]()
		while childNode != nil {
			var optionalResultForNode = Optional.Some(resultForNode)
			var childDictionary = dictionaryForNode(childNode as xmlNodePtr, &optionalResultForNode, false)
			if let childDictionary = childDictionary {
				childContentArray.append(childDictionary)
			}
			
			childNode = childNode.memory.next
		}
		
		if childContentArray.count > 0 {
			resultForNode["nodeChildArray"] = childContentArray
		}
	}
	
	var buffer = xmlBufferCreate()
	xmlNodeDump(buffer, currentNode.memory.doc, currentNode, 0, 0)
	
	if let rawContent = String.fromXmlChar(buffer.memory.content) {
		resultForNode["raw"] = rawContent
	}
	
	xmlBufferFree(buffer)
	return resultForNode
}

func performXPathQuery(doc: xmlDocPtr, query: String) -> [[String: Any]?]? {
	var xpathCtx: xmlXPathContextPtr = nil
	var xpathObj: xmlXPathObjectPtr = nil
	
	/* Create xpath evaluation context */
	xpathCtx = xmlXPathNewContext(doc)
	if xpathCtx == nil {
		println("Unable to create XPath context.")
		return nil;
	}
	
	/* Evaluate xpath expression */
	xpathObj = xmlXPathEvalExpression(UnsafePointer<xmlChar>(query.cStringUsingEncoding(NSUTF8StringEncoding)!), xpathCtx)
	if xpathObj == nil {
		println("Unable to evaluate XPath.")
		xmlXPathFreeContext(xpathCtx)
		return nil;
	}
	
	let nodes = xpathObj.memory.nodesetval
	if nodes == nil {
		println("Nodes was nil.")
		xmlXPathFreeObject(xpathObj)
		xmlXPathFreeContext(xpathCtx)
		return nil;
	}
	
	var resultNodes = [[String: Any]?]()
	var Nil: [String: Any]? = nil
	for i in 0 ..< Int(nodes.memory.nodeNr) {
		if let nodeDictionary = dictionaryForNode(nodes.memory.nodeTab[i], &Nil, false) {
			resultNodes.append(nodeDictionary)
		}
	}
	
	/* Cleanup */
	xmlXPathFreeObject(xpathObj)
	xmlXPathFreeContext(xpathCtx)
	
	return resultNodes
}

func performHTMLXPathQuery(document: NSData, query: String) -> [[String: Any]?]? {
	return performHTMLXPathQueryWithEncoding(document, query, nil)
}

func performHTMLXPathQueryWithEncoding(document: NSData, query: String, encoding: String?) -> [[String: Any]?]? {
	/* Load XML document */
	var encoded: [CChar]? = nil
	if let encoding = encoding {
		encoded = encoding.cStringUsingEncoding(NSUTF8StringEncoding)
	}
	
	var doc: xmlDocPtr = htmlReadMemory(UnsafePointer<CChar>(document.bytes), CInt(document.length), UnsafePointer<CChar>([""]), (encoded == nil) ? nil : UnsafePointer<CChar>(encoded!), CInt(HTML_PARSE_NOWARNING.value | HTML_PARSE_NOERROR.value))
	if doc == nil {
		NSLog("Unable to parse.")
		return nil
	}
	
	let result = performXPathQuery(doc, query)
	xmlFreeDoc(doc)
	
	return result
}

func performXMLXPathQuery(document: NSData, query: String) -> [[String: Any]?]? {
	return performXMLXPathQueryWithEncoding(document, query, nil)
}

func performXMLXPathQueryWithEncoding(document: NSData, query: String, encoding: String?) -> [[String: Any]?]? {
	/* Load XML document */
	var encoded: [CChar]? = nil
	if let encoding = encoding {
		encoded = encoding.cStringUsingEncoding(NSUTF8StringEncoding)
	}
	
	var doc: xmlDocPtr = htmlReadMemory(UnsafePointer<CChar>(document.bytes), CInt(document.length), UnsafePointer<CChar>([""]), UnsafePointer<CChar>(encoded!), CInt(XML_PARSE_RECOVER.value))
	
	if doc == nil {
		NSLog("Unable to parse.")
		return nil
	}
	
	let result = performXPathQuery(doc, query)
	xmlFreeDoc(doc)
	
	return result
}

// MARK: - Helpers
extension String {
	static func fromXmlChar(char: UnsafePointer<xmlChar>) -> String? {
		if char != nil {
			return String.fromCString(UnsafePointer<CChar>(char))
		} else {
			return nil
		}
	}
}
