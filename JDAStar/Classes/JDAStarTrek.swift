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
    
    public init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }
    
    func setSize(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }

    public func findPath(startPosition: AStarPosition, endPosition: AStarPosition, blockPositions: [AStarPosition]) -> [JDAStarNode]? {
        let startIndex = getIndexByPosition(col: startPosition.col, row: startPosition.row)
        let endIndex = getIndexByPosition(col: endPosition.col, row: endPosition.row)
        let blockIndexes = blockPositions.map{ getIndexByPosition(col: $0.col, row: $0.row )}
        return findPath(startIndex: startIndex, endIndex: endIndex, blockIndexes: blockIndexes)
    }
    
    public func findPath(startIndex: Int, endIndex: Int, blockIndexes: [Int]) -> [JDAStarNode]? {

        if isInvalidIndexes(startIndex, endIndex) {
            return nil
        }
        
        let (endCol, endRow) = getPositionByIndex(endIndex)
        let mapNodes = createNodes(blockIndexes)
        var openNodes = [JDAStarNode]()
        var closeNodes = [JDAStarNode]()
        let startNode = mapNodes[startIndex]
        openNodes.append(startNode)
        
        while openNodes.count > 0 {
            /// Sort nodes in ascending order of  f value
            openNodes.sort { $0.f < $1.f }
            let currNode = openNodes.first!
            if currNode.idx == endIndex {
                break
            }
            
            /// right, left, down, up
            let neighbours = [1, -1, cols, -cols]
            for nb in neighbours {
                let cp = getPositionByIndex(currNode.idx)
                let op = getPositionByIndex(nb)
                let newCol = cp.col + op.col
                let newRow = cp.row + op.row
                
                if isInvalidPosition(col: newCol, row: newRow) {
                    continue
                }
                
                let subIndex = currNode.idx + nb
                let subNode = mapNodes[subIndex]
                
                /// Skip blocked or searched node
                if subNode.isBlocked || closeNodes.contains(subNode) { continue }

                /// Set costs
                if subNode != startNode {
                    subNode.g = currNode.g + 1
                    subNode.h = abs(subNode.row - endRow) + abs(subNode.col - endCol)
                    subNode.f = subNode.g + subNode.h
                }
                /// Add node to waiting for search
                if !openNodes.contains(subNode) {
                    subNode.parent = currNode
                    openNodes.append(subNode)
                }
            }
            openNodes.removeFirst()
            closeNodes.append(currNode)
        }
        
        var nd = mapNodes[endIndex]
        if nd.parent == nil { return nil }
        
        var pathNodes: [JDAStarNode] = [nd]
        repeat {
            nd = nd.parent!
            pathNodes.append(nd)
        } while nd != startNode
        
        return pathNodes
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
    
}
