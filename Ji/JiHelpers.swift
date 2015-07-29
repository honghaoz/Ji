//
//  JiHelpers.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-21.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

extension String {
	static func fromXmlChar(char: UnsafePointer<xmlChar>) -> String? {
		if char != nil {
			return String.fromCString(UnsafePointer<CChar>(char))
		} else {
			return nil
		}
	}
}
