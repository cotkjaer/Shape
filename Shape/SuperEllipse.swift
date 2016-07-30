//
//  SuperEllipse.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic

public class SuperEllipse: Shape
{
    let n: CGFloat
    
    public init(n: CGFloat = CGFloat.𝑒)
    {
        self.n = n
    }
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        return UIBezierPath(superEllipseInRect: bounds, n: n)
    }
}

public func == (lhs: SuperEllipse, rhs: SuperEllipse) -> Bool
{
    return lhs.n == rhs.n
}


