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
    let isShowIndex = false
    var pathIndexes = [Int]()
    var starTrek: JDAStarTrek?
    var gridCollectionView: UICollectionView!
    var tapModeSegmentControl: UISegmentedControl!
    var pathModeSegmentControl: UISegmentedControl!
    var blockedIndexes = [97, 112, 126, 141, 155, 170, 184, 199, 128, 143, 159, 174, 190, 205]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupCollectionView()
        setupSegmentControl()
        
        starTrek = JDAStarTrek(cols: cols, rows: rows)
        findPathTo(targetIndex)
    }
    
    private func setupCollectionView() {
        let w = UIScreen.main.bounds.width - 16
        let layout = UICollectionViewFlowLayout()
        let cellSize = (w-16) / CGFloat(cols)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let h = cellSize * CGFloat(rows) + CGFloat(rows)
        
        gridCollectionView = UICollectionView(frame: CGRect(x: 8, y: 0, width: w, height: h), collectionViewLayout: layout)
        gridCollectionView.center.y = self.view.center.y + 30
        gridCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        self.view.addSubview(gridCollectionView)
    }
    
    private func setupSegmentControl() {
        tapModeSegmentControl = UISegmentedControl(items: ["Target", "Block"])
        tapModeSegmentControl.frame = CGRect(x: self.view.center.x - 170, y: gridCollectionView.frame.origin.y - 70, width: 150, height: 36)
        tapModeSegmentControl.selectedSegmentIndex = 0
        self.view.addSubview(tapModeSegmentControl)
        
        pathModeSegmentControl = UISegmentedControl(items: ["Staight", "Diagonal"])
        pathModeSegmentControl.frame = CGRect(x: self.view.center.x + 20, y: tapModeSegmentControl.frame.origin.y, width: 150, height: 36)
        pathModeSegmentControl.selectedSegmentIndex = 0
        pathModeSegmentControl.addTarget(self, action: #selector(pathModeSegmentControlChanged(_:)), for: .valueChanged)
        self.view.addSubview(pathModeSegmentControl)
    }   
}

extension ViewController {
    private func didSelectCell(_ idx: Int) {
        if tapModeSegmentControl.selectedSegmentIndex == 1 {
            setBlock(idx)
        }
        else if idx != startIndex && blockedIndexes.firstIndex(of: idx) == nil {
            targetIndex = idx
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
        gridCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cols * rows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.row == startIndex {
            cell.backgroundColor = #colorLiteral(red: 0.2174892128, green: 0.8184008598, blue: 0, alpha: 1)
        }
        else if indexPath.row == targetIndex {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
        }
        else if blockedIndexes.contains(indexPath.row) {
            cell.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
        }
        else if pathIndexes.contains(indexPath.row) {
            cell.backgroundColor = #colorLiteral(red: 0.4620369673, green: 0.8382686973, blue: 1, alpha: 1)
        }
        else {
            cell.backgroundColor = #colorLiteral(red: 0.8675442338, green: 0.8675442338, blue: 0.8675442338, alpha: 1)
        }
        
        if isShowIndex {
            for sv in cell.contentView.subviews {
                sv.removeFromSuperview()
            }
            let numLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            numLabel.textAlignment = .center
            numLabel.adjustsFontSizeToFitWidth = true
            numLabel.text = String(indexPath.row)
            numLabel.font = UIFont.systemFont(ofSize: 10)
            numLabel.textColor = .darkGray
            cell.contentView.addSubview(numLabel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(indexPath.row)
    }
}



