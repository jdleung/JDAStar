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
    var targetIndex = 127
    var pathIndexes = [Int]()
    var starTrek: JDAStarTrek?
    var gridCollectionView: UICollectionView!
    var modeSegmentControl: UISegmentedControl!
    var blockIndexes = [97, 112, 126, 141, 155, 170, 184, 199, 128, 143, 159, 174, 190, 205]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpCollectionView()
        setupSegmentControl()
        
        starTrek = JDAStarTrek(cols: cols, rows: rows)
        findPathTo(targetIndex)
    }
    
    private func setUpCollectionView() {
        let w = UIScreen.main.bounds.width - 16
        let layout = UICollectionViewFlowLayout()
        let cellSize = (w-16) / CGFloat(cols)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let h = cellSize * CGFloat(rows) + CGFloat(rows)
        
        gridCollectionView = UICollectionView(frame: CGRect(x: 8, y: 0, width: w, height: h), collectionViewLayout: layout)
        gridCollectionView.center.y = self.view.center.y
        gridCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        self.view.addSubview(gridCollectionView)
    }
    
    private func setupSegmentControl() {
        modeSegmentControl = UISegmentedControl(items: ["Target", "Block"])
        modeSegmentControl.frame = CGRect(x: 0, y: gridCollectionView.frame.origin.y - 50, width: 120, height: 36)
        modeSegmentControl.selectedSegmentIndex = 0
        modeSegmentControl.center.x = self.view.center.x
        self.view.addSubview(modeSegmentControl)
    }   
}

extension ViewController {
    private func didSelectCell(_ idx: Int) {
        if modeSegmentControl.selectedSegmentIndex == 1 {
            setBlock(idx)
        }
        else if idx > 0 && blockIndexes.firstIndex(of: idx) == nil {
            targetIndex = idx
        }
        findPathTo(targetIndex)
    }
    
    private func setBlock(_ idx: Int) {
        if let i = blockIndexes.firstIndex(of: idx) {
            blockIndexes.remove(at: i)
        }
        else {
            blockIndexes.append(idx)
        }
    }
    
    private func findPathTo(_ idx: Int) {
        pathIndexes.removeAll()
        if let pn = starTrek?.findPath(startIndex: 0,
                                    endIndex: idx,
                                    blockIndexes: blockIndexes) {
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
        
        if indexPath.row == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.2174892128, green: 0.8184008598, blue: 0, alpha: 1)
        }
        else if indexPath.row == targetIndex {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
        }
        else if blockIndexes.contains(indexPath.row) {
            cell.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
        }
        else if pathIndexes.contains(indexPath.row) {
            cell.backgroundColor = #colorLiteral(red: 0.4620369673, green: 0.8382686973, blue: 1, alpha: 1)
        }
        else {
            cell.backgroundColor = #colorLiteral(red: 0.8440209031, green: 0.8440209031, blue: 0.8440209031, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(indexPath.row)
    }
}



