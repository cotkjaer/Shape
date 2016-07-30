//
//  Drop.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Path

/// A stylized drop of liquid
public class Drop : Shape
{
    public override init() {}
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        let path = UIBezierPath(dropWithCenter: CGPointZero, radius: bounds.width / 2)
        
        path.transformToFit(bounds)
        
        path.flipVertically()

        return path
    }
}
