//
//  JiDocument.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-21.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public class JiDocument {
	private var isXML: Bool = true
	private(set) public var data: NSData?
	private(set) public var encoding: NSStringEncoding = NSUTF8StringEncoding
	
	public typealias htmlDocPtr = xmlDocPtr
	
	private(set) public var xmlDoc: xmlDocPtr = nil
	private(set) public var htmlDoc: htmlDocPtr {
		get { return xmlDoc }
		set { xmlDoc = newValue }
	}
	
	// MARK: - Init
	public required init?(data: NSData?, encoding: NSStringEncoding, isXML: Bool) {
		if let data = data where data.length > 0 {
			self.isXML = isXML
			self.data = data
			self.encoding = encoding
			
			let cBuffer = UnsafePointer<CChar>(data.bytes)
			let cSize = CInt(data.length)
			let cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding)
			let cfEncodingAsString: CFStringRef = CFStringConvertEncodingToIANACharSetName(cfEncoding)
			let cEncoding: UnsafePointer<CChar> = CFStringGetCStringPtr(cfEncodingAsString, 0)
			
			if isXML {
				let options = CInt(XML_PARSE_RECOVER.value)
				xmlDoc = xmlReadMemory(cBuffer, cSize, nil, cEncoding, options)
			} else {
				let options = CInt(HTML_PARSE_RECOVER.value | HTML_PARSE_NOWARNING.value | HTML_PARSE_NOERROR.value)
				htmlDoc = htmlReadMemory(cBuffer, cSize, nil, cEncoding, options)
			}
			if xmlDoc == nil { return nil }
		} else {
			return nil
		}
	}
	
	public convenience init?(data: NSData?, isXML: Bool) {
		self.init(data: data, encoding: NSUTF8StringEncoding, isXML: isXML)
	}
	
	// MARK: - Data Init
	public convenience init?(xmlData: NSData, encoding: NSStringEncoding) {
		self.init(data: xmlData, encoding: encoding, isXML: true)
	}
	
	public convenience init?(xmlData: NSData) {
		self.init(data: xmlData, isXML: true)
	}
	
	public convenience init?(htmlData: NSData, encoding: NSStringEncoding) {
		self.init(data: htmlData, encoding: encoding, isXML: false)
	}
	
	public convenience init?(htmlData: NSData) {
		self.init(data: htmlData, isXML: false)
	}
	
	// MARK: - URL Init
	public convenience init?(contentsOfURL url: NSURL, encoding: NSStringEncoding, isXML: Bool) {
		let data = NSData(contentsOfURL: url)
		self.init(data: data, encoding: encoding, isXML: isXML)
	}
	
	public convenience init?(contentsOfURL url: NSURL, isXML: Bool) {
		self.init(contentsOfURL: url, encoding: NSUTF8StringEncoding, isXML: isXML)
	}
	
	public convenience init?(xmlURL: NSURL) {
		self.init(contentsOfURL: xmlURL, isXML: true)
	}
	
	public convenience init?(htmlURL: NSURL) {
		self.init(contentsOfURL: htmlURL, isXML: false)
	}
	
	// MARK: - Deinit
	deinit {
		xmlFreeDoc(xmlDoc)
	}
	
	
	// MARK: -
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
