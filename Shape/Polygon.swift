//
//  Polygon.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Path
import Graphics
import Debug

/// N-Sided Convex Regular Polygon
public class Polygon : Shape
{
    public let sides : Int
    
    public init(sides : Int)
    {
        debugPrintIf(sides < 3, value: "A Polygon must have at least 3 sides, defaulting to 3")
        
        self.sides = max(3, abs(sides))
    }

    public var triangle : Bool { return sides == 3 }
    
    public var square : Bool { return sides == 4 }
    
    public var pentagon : Bool { return sides == 5 }
    
    public var hexagon : Bool { return sides == 6 }
    
    public var heptagon : Bool { return sides == 7 }
    
    public var octagon : Bool { return sides == 8 }
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        let radius = min(bounds.size.width, bounds.size.height) / 2
        
        let path = UIBezierPath(convexRegularPolygonWithNumberOfSides: sides, circumscribedCircleRadius: radius, turned: false)
        
        path.rotate(π_2 - π / sides)

        return path
    }

    override public var description : String { return "\(sides)-sided polygon" }
    
    // MARK: - Equality
    
    override func equalTo(other: Shape) -> Bool
    {
        guard let polygon = other as? Polygon else { return false }
        
        return polygon.sides == sides
    }
}
