//
//  Heart.swift
//  Shape
//
//  Created by Christian Otkjær on 29/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Path

/// A stylized drop of liquid
public class Heart : Shape
{
    public override init() {}
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        let path = UIBezierPath(heartInRect: bounds)
        
        path.flipVertically()
        
        return path
    }
}


