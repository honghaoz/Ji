//
//  JiNode.swift
//  Ji
//
//  Created by Honghao Zhang on 2015-07-20.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

public class JiNode {
	public var document: JiDocument?
	public weak var parent: JiNode?
	public var children = [JiNode]()
}