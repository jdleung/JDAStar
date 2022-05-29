//
//  ViewController.swift
//  JDAStar_MacOS_Example
//
//  Created by jdleung on 2022/5/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Cocoa
import JDAStar

class ViewController: NSViewController {

    let cols = 15
    let rows = 20
    let startIndex = 0
    var targetIndex = 127
    let isShowIndex = true
    var pathIndexes = [Int]()
    var buttonCells = [NSButton]()
    var starTrek: JDAStarTrek?
    var boardView: NSView!
    var tapModeSegmentControl: NSSegmentedControl!
    var pathModeSegmentControl: NSSegmentedControl!
    var blockedIndexes = [97, 112, 126, 141, 155, 170, 184, 199, 128, 143, 159, 174, 190, 205]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBoardView()
        setupSegmentControls()

        starTrek = JDAStarTrek(cols: cols, rows: rows)
        findPathTo(targetIndex)
    }

    private func setBoardView() {
        let cellSize = (self.view.frame.width - 20) / CGFloat(cols)
        let bw = cellSize * CGFloat(cols)
        let bh = cellSize * CGFloat(rows)
        boardView = NSView(frame: NSRect(x: self.view.frame.width/2 - bw/2, y: 50, width: bw, height: bh))
        self.view.addSubview(boardView)
        
        var t = 0
        var y = bh - cellSize
        for _ in 0..<rows {
            for j in 0..<cols {
                let b = NSButton(frame: NSRect(x: CGFloat(j) * cellSize, y: y, width: cellSize, height: cellSize))
                b.tag = t
                b.title = String(t)
                b.action = #selector(didSelectCell(_:))
                b.isBordered = false
                b.wantsLayer = true
                b.layer?.borderWidth = 0.5
                b.layer?.borderColor = NSColor.darkGray.cgColor
                boardView.addSubview(b)
                buttonCells.append(b)
                t += 1
            }
            y -= cellSize
        }
    }
    
    private func setupSegmentControls() {
        tapModeSegmentControl = NSSegmentedControl(labels: ["Target", "Block"], trackingMode: .selectOne, target: nil, action: nil)
        tapModeSegmentControl.frame = CGRect(x: 10, y: boardView.frame.origin.y + boardView.frame.height + 40, width: 150, height: 36)
        tapModeSegmentControl.selectedSegment = 0
        self.view.addSubview(tapModeSegmentControl)
        
        pathModeSegmentControl = NSSegmentedControl(labels: ["Staight", "Diagonal"], trackingMode: .selectOne, target: self, action: #selector(pathModeSegmentControlChanged(_:)))
        pathModeSegmentControl.frame = CGRect(x: 200, y: tapModeSegmentControl.frame.origin.y, width: 150, height: 36)
        pathModeSegmentControl.selectedSegment = 0
        self.view.addSubview(pathModeSegmentControl)
    }

}

extension ViewController {
    @objc
    private func didSelectCell(_ sender: NSButton) {
        if tapModeSegmentControl.selectedSegment == 1 {
            setBlock(sender.tag)
        } else
        if sender.tag != startIndex && blockedIndexes.firstIndex(of: sender.tag) == nil {
            targetIndex = sender.tag
        }
        findPathTo(targetIndex)
    }
    
    private func setBlock(_ idx: Int) {
        if let i = blockedIndexes.firstIndex(of: idx) {
            blockedIndexes.remove(at: i)
        }
        else {
            blockedIndexes.append(idx)
        }
    }
    
    @objc
    private func pathModeSegmentControlChanged(_ sender: NSSegmentedControl) {
        starTrek?.isDiagonalEnabled = sender.selectedSegment == 1
        findPathTo(targetIndex)
    }
    
    private func findPathTo(_ idx: Int) {
        pathIndexes.removeAll()
        if let pn = starTrek?.findPath(startIndex: startIndex,
                                    endIndex: idx,
                                    blockedIndexes: blockedIndexes) {
            pathIndexes = pn.map{ $0.idx }
        }
        updateButtons()
    }
    
    func updateButtons() {
        for b in buttonCells {
            if b.tag == startIndex {
                b.layer?.backgroundColor = #colorLiteral(red: 0.2174892128, green: 0.8184008598, blue: 0, alpha: 1)
            }
            else if b.tag == targetIndex {
                b.layer?.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
            }
            else if blockedIndexes.contains(b.tag) {
                b.layer?.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
            }
            else if pathIndexes.contains(b.tag) {
                b.layer?.backgroundColor = #colorLiteral(red: 0.4620369673, green: 0.8382686973, blue: 1, alpha: 1)
            }
            else {
                b.layer?.backgroundColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
            }
            
            b.title = isShowIndex ? String(b.tag) : ""
            
            if let mutableAttributedTitle = b.attributedTitle.mutableCopy() as? NSMutableAttributedString {
                mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.darkGray, range: NSRange(location: 0, length: mutableAttributedTitle.length))
                b.attributedTitle = mutableAttributedTitle
            }
        }
    }
}
