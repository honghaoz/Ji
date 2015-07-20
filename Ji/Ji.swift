//
//  Ji.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public class Ji {
	private(set) public var data: NSData
	private(set) public var encoding: String?
	private var isXML = false
	
	public required init(data: NSData, encoding: String?, isXML: Bool) {
		self.data = data
		self.encoding = encoding
		self.isXML = isXML
	}
	
	public convenience init(data: NSData, isXML: Bool) {
		self.init(data: data, encoding: nil, isXML: isXML)
	}
	
	public convenience init(XMLData: NSData, encoding: String) {
		self.init(data: XMLData, encoding: encoding, isXML: true)
	}
	
	public convenience init(XMLData: NSData) {
		self.init(data: XMLData, encoding: nil, isXML: true)
	}
	
	public convenience init(HTMLData: NSData, encoding: String) {
		self.init(data: HTMLData, encoding: encoding, isXML: false)
	}
	
	public convenience init(HTMLData: NSData) {
		self.init(data: HTMLData, encoding: nil, isXML: false)
	}
	
	public class func JiWithData(data: NSData, encoding: String, isXML: Bool) -> Ji {
		return self(data: data, encoding: encoding, isXML: isXML)
	}
	
	public class func JiWithData(data: NSData, isXML: Bool) -> Ji {
		return self(data: data, encoding: nil, isXML: isXML)
	}
	
	public class func JiWithXMLData(XMLData: NSData, encoding: String) -> Ji {
		return self(data: XMLData, encoding: encoding, isXML: true)
	}
	
	public class func JiWithXMLData(XMLData: NSData) -> Ji {
		return self(data: XMLData, encoding: nil, isXML: true)
	}
	
	public class func JiWithHTMLData(HTMLData: NSData, encoding: String) -> Ji {
		return self(data: HTMLData, encoding: encoding, isXML: false)
	}
	
	public class func JiWithHTMLData(HTMLData: NSData) -> Ji {
		return self(data: HTMLData, encoding: nil, isXML: false)
	}
	
	// MARK: -
	public func searchWithXPathQuery(xPathOrCSS: String) -> [JiElement] {
		var detailNodes: [[String: Any]?]? = nil
		if isXML {
			detailNodes = performXMLXPathQueryWithEncoding(data, xPathOrCSS, encoding)
		} else {
			detailNodes = performHTMLXPathQueryWithEncoding(data, xPathOrCSS, encoding)
		}
		
		var elements = [JiElement]()
		if let detailNodes = detailNodes {
			for newNode in detailNodes {
				elements.append(JiElement.elementWithNode(newNode, isXML: isXML, withEncoding: encoding))
			}
		}
		
		return elements
	}
	
	public func peekAtSearchWithXPathQuery(xPathOrCSS: String) -> JiElement? {
		var elements = searchWithXPathQuery(xPathOrCSS)
		return elements.first
	}
}
