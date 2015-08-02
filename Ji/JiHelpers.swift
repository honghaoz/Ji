//
//  JiHelpers.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-21.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

extension String {
	/**
	Creates a new String from a xmlChar CString, using UTF-8 encoding.
	
	:param: char xmlChar CString
	
	:returns: Returns nil if the CString is NULL or if it contains ill-formed UTF-8 code unit sequences.
	*/
	static func fromXmlChar(char: UnsafePointer<xmlChar>) -> String? {
		if char != nil {
			return String.fromCString(UnsafePointer<CChar>(char))
		} else {
			return nil
		}
	}
}
