//
//  Rectangle.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic

public class Rectangle: Shape
{
    public init(ratio: (width: Int, height: Int))
    {
        assert(ratio.width > 0, "width must be > 0")
        assert(ratio.height > 0, "height must be > 0")
        
        self.ratio = ratio
    }
    
    public let ratio : (width: Int, height: Int)
    
    var square : Bool { return ratio.height == ratio.width }
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
//        guard ratio.height != 0 && ratio.width != 0 else { return UIBezierPath() }
        
        var size = bounds.size
        let widthFactor = size.width / ratio.width
        let heightFactor = size.height / ratio.height
        
        if widthFactor > heightFactor
        {
            size.width = ratio.width * heightFactor
        }
        else if widthFactor < heightFactor
        {
            size.height = ratio.height * widthFactor
        }
        
        return UIBezierPath(rect: CGRect(center: bounds.center, size: size))
    }
    
    // MARK: - Equality
    
    override func equalTo(other: Shape) -> Bool
    {
        guard let rectangle = other as? Rectangle else { return false }
        
        return rectangle.ratio == ratio
    }
}
