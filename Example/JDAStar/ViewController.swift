//
//  ViewController.swift
//  JDAStar
//
//  Created by jdleung on 05/25/2022.
//  Copyright (c) 2022 jdleung. All rights reserved.
//

import UIKit
import JDAStar

class ViewController: UIViewController {
        
    let cols = 15
    let rows = 20
    let startIndex = 0
    var targetIndex = 127
    let isShowIndex = true
    var pathIndexes = [Int]()
    var buttonCells = [UIButton]()
    var starTrek: JDAStarTrek?
    var boardView: UIView!
    var tapModeSegmentControl: UISegmentedControl!
    var pathModeSegmentControl: UISegmentedControl!
    var blockedIndexes = [97, 112, 126, 141, 155, 170, 184, 199, 128, 143, 159, 174, 190, 205]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setBoardView()
        setupSegmentControl()
        
        starTrek = JDAStarTrek(cols: cols, rows: rows)
        findPathTo(targetIndex)
    }
    
    private func setBoardView() {
        let cellSize = (self.view.frame.width - 20) / CGFloat(cols)
        let bw = cellSize * CGFloat(cols)
        let bh = cellSize * CGFloat(rows)
        
        boardView = UIView(frame: CGRect(x: 0, y: 300, width: bw, height: bh))
        boardView.center.x = self.view.center.x
        boardView.center.y = self.view.center.y + 30
        self.view.addSubview(boardView)
        
        var t = 0
        for i in 0..<rows {
            for j in 0..<cols {
                let b = UIButton(frame: CGRect(x: CGFloat(j) * cellSize, y: CGFloat(i) * cellSize, width: cellSize, height: cellSize))
                b.tag = t
                b.addTarget(self, action: #selector(didSelectCell(_:)), for: .touchUpInside)
                b.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                b.titleLabel?.adjustsFontSizeToFitWidth = true
                b.setTitleColor(.darkGray, for: .normal)
                b.layer.borderColor = UIColor.lightGray.cgColor
                b.layer.borderWidth = 0.5
                boardView.addSubview(b)
                buttonCells.append(b)
                t += 1
            }
        }
    }
    
    private func setupSegmentControl() {
        tapModeSegmentControl = UISegmentedControl(items: ["Target", "Block"])
        tapModeSegmentControl.frame = CGRect(x: self.view.center.x - 170, y: boardView.frame.origin.y - 70, width: 150, height: 36)
        tapModeSegmentControl.selectedSegmentIndex = 0
        self.view.addSubview(tapModeSegmentControl)
        
        pathModeSegmentControl = UISegmentedControl(items: ["Staight", "Diagonal"])
        pathModeSegmentControl.frame = CGRect(x: self.view.center.x + 20, y: tapModeSegmentControl.frame.origin.y, width: 150, height: 36)
        pathModeSegmentControl.selectedSegmentIndex = 0
        pathModeSegmentControl.addTarget(self, action: #selector(pathModeSegmentControlChanged(_:)), for: .valueChanged)
        self.view.addSubview(pathModeSegmentControl)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ViewController {
    @objc
    private func didSelectCell(_ sender: UIButton) {
        if tapModeSegmentControl.selectedSegmentIndex == 1 {
            setBlock(sender.tag)
        }
        else if sender.tag != startIndex && blockedIndexes.firstIndex(of: sender.tag) == nil {
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
    private func pathModeSegmentControlChanged(_ sender: UISegmentedControl) {
        starTrek?.isDiagonalEnabled = sender.selectedSegmentIndex == 1
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
                b.backgroundColor = #colorLiteral(red: 0.2174892128, green: 0.8184008598, blue: 0, alpha: 1)
            }
            else if b.tag == targetIndex {
                b.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
            }
            else if blockedIndexes.contains(b.tag) {
                b.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
            }
            else if pathIndexes.contains(b.tag) {
                b.backgroundColor = #colorLiteral(red: 0.4620369673, green: 0.8382686973, blue: 1, alpha: 1)
            }
            else {
                b.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            }
            
            if isShowIndex {
                b.setTitle(String(b.tag), for: .normal)
            } else {
                b.setTitle("", for: .normal)
            }
        }
    }
}
