//
//  PolygonsCollectionViewController.swift
//  Shape
//
//  Created by Christian Otkjær on 30/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Shape

private let reuseIdentifier = "Cell"

class PolygonsCollectionViewController: UICollectionViewController
{
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 255
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 12
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        if let pCell = cell as? PolygonsCollectionViewCell
        {
            pCell.polygonView?.shape = Polygon(sides: indexPath.item + 3)
            
            let s = CGFloat(indexPath.section)
            let i = CGFloat(indexPath.item)
            
            pCell.polygonView?.fillColor = UIColor(red: s / 255 + 1 / (i + 1), green: i / 12, blue: 0.5 + 1 / (s + i + 2), alpha: 1)
        }
        
        return cell
    }
}
