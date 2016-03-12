//
//  XML.swift
//  XML
//
//  Created by Honghao Zhang on 2015-07-21.
//  Copyright (c) 2015 Honghao Zhang (张宏昊)
//  Copyright (c) 2016 Zewo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Data
import String

import CLibXML2

public class XMLDocument {
    /// A flag specifies whether the data is XML or not.
    internal var isXML: Bool = true
    /// The XML/HTML data.
    private(set) public var data: Data?
    
    public typealias htmlDocPtr = xmlDocPtr
    /// The xmlDocPtr for this document
    private(set) public var xmlDoc: xmlDocPtr = nil
    /// Alias for xmlDoc
    private(set) public var htmlDoc: htmlDocPtr {
        get { return xmlDoc }
        set { xmlDoc = newValue }
    }
    
    
    
    // MARK: - Init
    
    /**
    Initializes a XML document object with the supplied data, encoding and boolean flag.
    
    - parameter data:     The XML/HTML data.
    - parameter isXML:    Whether this is a XML data, true for XML, false for HTML.
    
    - returns: The initialized XML document object or nil if the object could not be initialized.
    */
    public required init?(data: Data?, isXML: Bool) {
        if let data = data where data.count > 0 {
            self.isXML = isXML
            self.data = data

            var utf8Encoding: Int8 = 1// = UnsafeMutablePointer<Int8>()

            if isXML {
                let options = CInt(XML_PARSE_RECOVER.rawValue)
                data.withUnsafeBufferPointer { dataPtr in
                    let pointer = UnsafePointer<Int8>(dataPtr.baseAddress)
                    xmlDoc = xmlReadMemory(pointer, Int32(dataPtr.count), nil, &utf8Encoding, options)
                }
            } else {
                let options = CInt(HTML_PARSE_RECOVER.rawValue | HTML_PARSE_NOWARNING.rawValue | HTML_PARSE_NOERROR.rawValue)
                data.withUnsafeBufferPointer { dataPtr in
                    let pointer = UnsafePointer<Int8>(dataPtr.baseAddress)
                    xmlDoc = htmlReadMemory(pointer, Int32(dataPtr.count), nil, &utf8Encoding, options)
                }
            }
            if xmlDoc == nil { return nil }
        } else {
            return nil
        }
    }
    
    
    // MARK: - Data Init
    
    /**
    Initializes a XML document object with the supplied XML data and encoding.
    
    - parameter xmlData:  The XML data.

    - returns: The initialized XML document object or nil if the object could not be initialized.
    */
    public convenience init?(xmlData: Data) {
        self.init(data: xmlData, isXML: true)
    }

    /**
    Initializes a XML document object with the supplied HTML data and encoding.
    
    - parameter htmlData: The HTML data.

    - returns: The initialized XML document object or nil if the object could not be initialized.
    */
    public convenience init?(htmlData: Data) {
        self.init(data: htmlData, isXML: false)
    }
    
    // MARK:  - String Init
    
    /**
    Initializes a XML document object with a XML string and it's encoding.
    
    - parameter xmlString: XML string.

    - returns: The initialized XML document object or nil if the object could not be initialized.
    */
    public convenience init?(xmlString: String) {
        self.init(data: Data(xmlString), isXML: true)
    }
    
    /**
    Initializes a XML document object with a HTML string and it's encoding.
    
    - parameter htmlString: HTML string.

    - returns: The initialized XML document object or nil if the object could not be initialized.
    */
    public convenience init?(htmlString: String) {
        self.init(data: Data(htmlString), isXML: false)
    }
    
    
    // MARK: - Deinit
    deinit {
        xmlFreeDoc(xmlDoc)
    }
    
    
    
    // MARK: - Public methods
    
    /// Root node of this XML document object.
    public lazy var rootNode: XMLNode? = {
        let rootNodePointer = xmlDocGetRootElement(self.xmlDoc)
        if rootNodePointer == nil {
            return nil
        } else {
            return XMLNode(xmlNode: rootNodePointer, xmlDocument: self)
        }
    }()
    
    /**
    Perform XPath query on this document.
    
    - parameter xPath: XPath query string.
    
    - returns: An array of XMLNode or nil if rootNode is nil. An empty array will be returned if XPath matches no nodes.
    */
    public func xPath(xPath: String) -> [XMLNode]? {
        return self.rootNode?.xPath(xPath)
    }
}



// MARK: - Equatable
extension XMLDocument: Equatable { }
public func ==(lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    return lhs.xmlDoc == rhs.xmlDoc
}

// MARK: - CustomStringConvertible
extension XMLDocument: CustomStringConvertible {
    public var description: String {
        return rootNode?.rawContent ?? "nil"
    }
}

// MARK: - CustomDebugStringConvertible
extension XMLDocument: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
