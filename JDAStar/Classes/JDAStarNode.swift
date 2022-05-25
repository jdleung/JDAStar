//
//  JDAStarNode.swift
//  JDAStar_Example
//
//  Created by jdleung on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

public class JDAStarNode: NSObject {
    
    /// Cost of the transversal: g + h
    public var f: Int = 0
    
    /// The actual cost of transversal from the starting node to the current node
    public var g: Int = 0
    
    /// The estimate cost of transversal from the current node to the target node
    public var h: Int = 0
    
    /// Parenent node
    public var parent: JDAStarNode?
    
    public var idx: Int = 0
    public var row = 0
    public var col = 0
    public var isBlocked = false
}

