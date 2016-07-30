//
//  Star.swift
//  Shape
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public class Star: Shape
{
    /// The number of spikes in the star (should be >= 3)
    public let spikes: Int
    
    /// The factor that determines how long the spikes should be relative to the radius of the star
    public let innerRadiusFactor: CGFloat
    
    public init(spikes: Int, innerRadius: CGFloat = 0.5)
    {
        self.spikes = max(3, spikes)
        self.innerRadiusFactor = max(0, min(1, innerRadius))
    }
    
    public override func pathForBounds(bounds: CGRect) -> UIBezierPath
    {
        let radius = min(bounds.width, bounds.height)
        
        let path = UIBezierPath(starWithCenter: bounds.center, innerRadius: radius * innerRadiusFactor, outerRadius: radius, spikes: spikes)
        
        return path
    }
    override public var description : String { return "\(spikes)-spiked star (innerRadius: \(innerRadiusFactor)" }
    
    // MARK: - Equality
    
    override func equalTo(other: Shape) -> Bool
    {
        guard let star = other as? Star else { return false }
        
        return star.spikes == spikes && innerRadiusFactor == star.innerRadiusFactor
    }
}