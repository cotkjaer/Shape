//
//  Circle.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public class Circle: Shape
{
    public override init() {}
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        let diameter = min(bounds.size.width, bounds.size.height)
        
        let frame = CGRect(center: bounds.center, size: CGSize(width: diameter, height: diameter))
        
        return UIBezierPath(ovalInRect: frame)
    }    
}