//
//  ASearch.swift
//  AStar_Example
//
//  Created by jdleung on 2022/5/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public struct AStarPosition {
    var col: Int
    var row: Int
    public init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
}

public class JDAStarTrek: NSObject {
    
    var cols: Int
    var rows: Int
    
    /// Whether to allow finding diagonal path.
    public var isDiagonalEnabled = false
    
    /**
     Initialize
     
     - parameter cols:               The number of horizonal cells in the map.
     - parameter rows:               The number of vertical cells in the map.
     - parameter isDiagonalEnabled:  Whether to allow finding diagonal path.
     */
    public init(cols: Int, rows: Int, isDiagonalEnabled: Bool = false) {
        self.cols = cols
        self.rows = rows
        self.isDiagonalEnabled = isDiagonalEnabled
    }
    
    /**
     Set the size of map
     
     - parameter cols: The number of horizonal cells in the map.
     - parameter rows: The number of vertical cells in the map.
     */
    public func setMapSize(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }
    
    /**
     Get the path nodes by specified positions
     
     - parameter startPosition:   The start position in the map.
     - parameter endPosition:     The end position in the map.
     - parameter blockPositions:  The positions that are blocked or to be skipped
     - Returns: An array of `JDAStarNode`.
     */
    public func findPath(startPosition: AStarPosition, endPosition: AStarPosition, blockedPositions: [AStarPosition]) -> [JDAStarNode]? {
        let startIndex = getIndexByPosition(col: startPosition.col, row: startPosition.row)
        let endIndex = getIndexByPosition(col: endPosition.col, row: endPosition.row)
        let blockedIndexes = blockedPositions.map{ getIndexByPosition(col: $0.col, row: $0.row )}
        return findPath(startIndex: startIndex, endIndex: endIndex, blockedIndexes: blockedIndexes)
    }
    
    /**
     Get the path nodes by specified indexes
     
     - parameter startIndex:    The start index in the map array.
     - parameter endIndex:      The end index in the map array.
     - parameter blockIndexes:  The indexes that are blocked or to be skipped
     - Returns: An array of `JDAStarNode`.
     */
    public func findPath(startIndex: Int, endIndex: Int, blockedIndexes: [Int]) -> [JDAStarNode]? {
        if isInvalidIndexes(startIndex, endIndex) {
            return nil
        }
        
        let (endCol, endRow) = getPositionByIndex(endIndex)
        let mapNodes = createNodes(blockedIndexes)
        let startNode = mapNodes[startIndex]
        var closeNodes: [JDAStarNode] = []
        var openNodes: [JDAStarNode] = [startNode]
        
        while openNodes.count > 0 {
            /// Sort nodes in ascending order of f value
            openNodes.sort { $0.f < $1.f }
            let currNode = openNodes.first!
            if currNode.idx == endIndex {
                break
            }

            for nb in getNeigbourPositions(of: currNode) {
                let subIndex = getIndexByPosition(col: nb.col, row: nb.row)
                let subNode = mapNodes[subIndex]
                
                if subNode.isBlocked || closeNodes.contains(subNode) { continue }

                if subNode != startNode {
                    let cost = calculateCosts(currNode: currNode,
                                               subNode: subNode,
                                               endCol: endCol,
                                               endRow: endRow)
                    subNode.g = cost.g
                    subNode.h = cost.h
                    subNode.f = cost.f
                }
                
                if !openNodes.contains(subNode) {
                    subNode.parent = currNode
                    openNodes.append(subNode)
                }
            }
            openNodes.removeFirst()
            closeNodes.append(currNode)
        }

        var node = mapNodes[endIndex]
        if node.parent == nil { return nil }
        
        var pathNodes = [JDAStarNode]()
        while node != startNode {
            pathNodes.append(node)
            guard let pn = node.parent else {
                return nil
            }
            node = pn
        }

        return pathNodes.reversed()
    }
    
    private func getPositionByIndex(_ index: Int) -> (col: Int, row: Int) {
        let row = index / cols
        let col = index % cols
        return (col, row)
    }
    
    private func getIndexByPosition(col: Int, row: Int) -> Int {
        return row * cols + col
    }
    
    private func isInvalidIndexes(_ startIndex: Int, _ endIndex: Int) -> Bool {
        return startIndex == endIndex
            || startIndex < 0
            || endIndex < 0
            || startIndex >= cols * rows
            || endIndex >= cols * rows
    }
    
    private func isInvalidPosition(col: Int, row: Int) -> Bool {
        return row >= rows || row < 0 || col >= cols || col < 0
    }
    
    private func createNodes(_ blockIndexes: [Int]) -> [JDAStarNode] {
        var nodes = [JDAStarNode]()
        for i in 0..<rows*cols {
            let nd = JDAStarNode()
            let (col, row) = getPositionByIndex(i)
            nd.idx = i
            nd.col = col
            nd.row = row
            nd.isBlocked = blockIndexes.contains(i)
            nodes.append(nd)
        }
        return nodes
    }
    
    private func getNeigbourPositions(of currNode: JDAStarNode) -> [AStarPosition] {
        /// right, left, down, up
        var offsets = [AStarPosition(col: 1, row: 0),
                       AStarPosition(col: 0, row: 1),
                       AStarPosition(col: 0, row: -1),
                       AStarPosition(col: -1, row: 0)]
        
        /// top left, top right, bottom left, bottom right
        if isDiagonalEnabled {
            let corners = [AStarPosition(col: -1, row: -1),
                           AStarPosition(col: 1, row: -1),
                           AStarPosition(col: -1, row: 1),
                           AStarPosition(col: 1, row: 1)]
            offsets += corners
        }
        
        var positions = [AStarPosition]()
        for os in offsets {
            let newCol = currNode.col + os.col
            let newRow = currNode.row + os.row
            if isInvalidPosition(col: newCol, row: newRow) {
                continue
            }
            positions.append(AStarPosition(col: newCol, row: newRow))
        }
        return positions
    }
    
    private func calculateCosts(currNode: JDAStarNode, subNode: JDAStarNode, endCol: Int, endRow: Int) -> (g: Double, h: Double, f: Double) {
        let dx = Double(abs(subNode.col - endCol))
        let dy = Double(abs(subNode.row - endRow))
        let dv = 10.0
        let g = currNode.g + dv
        var h = 0.0
        
        if isDiagonalEnabled {
            /// Diagonal Distance:
            /// When we are allowed to move in eight directions only
            let dv2 = sqrt(2) * dv
            h = dv * (dx + dy) + (dv2 - 2 * dv) * min(dx, dy)
            
            /// Euclidean Distance
            /// When we are allowed to move in any directions
            /// h = sqrt(dx * dx + dy * dy) * dv
        } else {
            /// Manhattan Distance
            /// When we are allowed to move only in four directions only (left, right, up, down)
            h = (dx + dy) * dv
        }
        
        let f = g + h
        
        return (g, h, f)
    }
    
    private func isCornerPosition( _ subNode: JDAStarNode, _ currNode: JDAStarNode) -> Bool {
        return abs(subNode.col - currNode.col) == 1 && abs(subNode.row - currNode.row) == 1
    }
}
