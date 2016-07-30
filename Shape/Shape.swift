//
//  Shape.swift
//  Bezier
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public class Shape : Equatable, CustomStringConvertible
{
    /// Returns a path for this shape that fits into the given bounds
    func pathForBounds(bounds: CGRect) -> UIBezierPath { return UIBezierPath() }

    // MARK: - CustomStringConvertible
    public var description : String { return "\(self.dynamicType)" }
    
    func equalTo(other: Shape) -> Bool
    {
        return self.dynamicType == other.dynamicType
    }
}

//MARK: - Equatable

public func == (lhs: Shape, rhs: Shape) -> Bool
{
    return lhs.equalTo(rhs) && rhs.equalTo(lhs)
}

// MARK: - CustomStringConvertible

extension Shape : CustomDebugStringConvertible
{
    public var debugDescription : String { return description }
    
}


