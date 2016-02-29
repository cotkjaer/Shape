//
//  Shape.swift
//  Bezier
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Silverback

public protocol Shape
{
    var name : String { get }
    
    // Reference
    func path() -> UIBezierPath
    
    func path(bounds: CGRect) -> UIBezierPath
}

// MARK: - Default implementation

public extension Shape
{
    var name : String { return String(self.dynamicType) }
    
    func path(bounds: CGRect) -> UIBezierPath
    {
        let path = self.path()
        
        let pathBounds = path.bounds
        
        let scale = min(bounds.width / pathBounds.width, bounds.height / pathBounds.height)
        
        path.applyTransform(CGAffineTransformMakeScale(scale, scale))
        
        let deltaCenter = bounds.center - path.bounds.center
        
        path.applyTransform(CGAffineTransformMakeTranslation(deltaCenter.x, deltaCenter.y))
        
        return path
    }
}

public class Ellipse: Shape
{
    var ratio : (width: Int, height: Int) = (1, 1)
    
    var circle : Bool { return ratio.height == ratio.width }
    
    public func path() -> UIBezierPath
    {
        let rect = CGRect(size: CGSize(width: CGFloat(ratio.width * 10), height: CGFloat(ratio.width * 10)))
        
        return UIBezierPath(ovalInRect: rect)
    }
    
    public func path(bounds: CGRect) -> UIBezierPath
    {
        // scale to fill
        guard ratio.height != 0 && ratio.width != 0 else { return UIBezierPath() }
        
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
        
        return UIBezierPath(ovalInRect: CGRect(center: bounds.center, size: size))
    }
}

public class Circle: Shape
{
    public func path() -> UIBezierPath
    {
        return UIBezierPath(ovalInRect: CGRect(size: CGSize(widthAndHeight: 10)))
    }
}

/// Shape is a N-Sided Convex Regular Polygon
public class Polygon : Shape
{
    let n : Int
    
    required public init(sides : Int)
    {
        debugPrintIf(sides < 3, value: "A polygon must have at least three sides, defaulting to 3")
        
        n = max(3, sides)
    }
    
    public func path() -> UIBezierPath
    {
        let path = UIBezierPath(convexRegularPolygonWithNumberOfSides: n, circumscribedCircleRadius: 10, turned: false)
        
        path.applyTransform(CGAffineTransformMakeRotation(π_2 - π / n))
        
        return path
    }
    
    
//    public func path(bounds: CGRect, align: ShapeAlignment) -> UIBezierPath
//    {
//        return path(bounds, align: align, turned: false)
//    }
//    
//    public func path(bounds: CGRect, align: ShapeAlignment, turned: Bool) -> UIBezierPath
//    {
////        let alpha = π2 / n
////        let beta = π - alpha
//        
//        let h = min(bounds.width, bounds.height)
//        let radius : CGFloat
////        let center : CGPoint
//        
//        if n.odd
//        {
//            radius = h / (1 + cos(π / n))
////            center = bounds.center - CGVectorMake(0, 0.5 * radius * ( 1 - cos(π/n)))
//        }
//        else
//        {
//            radius = h / (2 * cos(π / n))
////            center = bounds.center
//        }
//        
//        let path = UIBezierPath(convexRegularPolygonWithNumberOfSides: n,
//            circumscribedCircleRadius: radius, turned: turned)
//
//       path.applyTransform(CGAffineTransformMakeRotation(π_2 - π / n))
//
//        var pathBounds = path.bounds
//        
//        let scaleFactor = min(bounds.width / pathBounds.width, bounds.height / pathBounds.height)
//        
//        path.applyTransform(CGAffineTransformMakeScale(scaleFactor, scaleFactor))
//        
//        
//        pathBounds = path.bounds
//        
//        path.applyTransform(CGAffineTransformMakeTranslation(bounds.center.x - pathBounds.center.x, bounds.center.y - pathBounds.center.y))
//        
//        return path
//    }
}

public extension UIBezierPath
{
    /**
     Initializeses the bezier curve as a N-Sided Convex Regular Polygon
     
     - parameter n: number of sides
     - parameter center: center og the polygon. Default is (0,0)
     - parameter radius: the radius of the circumscribed circle
     - parameter turned: if *true* the polygon is rotated (counterclockwise around center) to let the rightmost edge be vertical. If *false* the rightmost corner is directly right of the center. Default is *false*
     */
    convenience init(
        convexRegularPolygonWithNumberOfSides n: Int,
        center: CGPoint = CGPointZero,
        circumscribedCircleRadius radius: CGFloat,
        turned: Bool = false)
    {
        precondition(n > 2, "A polygon must have at least three sides")
        
        self.init()
        
        moveToPoint(CGPoint(x: radius, y: 0))
        
        for theta in (1 ..< n).map({ $0 * 2 * π / CGFloat(n)} )
        {
            addLineToPoint(CGPoint(x: radius * cos(theta), y: radius * sin(theta)))
        }
        
        closePath()
        
        if turned
        {
            applyTransform(CGAffineTransformMakeRotation(π / CGFloat(n)))
        }
        
        applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
    }
    
    convenience init(pentagonWithCenter center: CGPoint = CGPointZero, sideLength: CGFloat, turned: Bool = false)
    {
        self.init(convexRegularPolygonWithNumberOfSides: 5, center: center, circumscribedCircleRadius: sideLength, turned: turned)
    }
}

public class Pentagon : Polygon
{
    public required init(sides: Int)
    {
        debugPrintIf(sides != 5, value: "A Pentagon must have five sides, defaulting to 5")

        super.init(sides: 5)
    }
}


public class Rectangle: Shape
{
    var ratio : (width: Int, height: Int) = (1, 1)
    
    var square : Bool { return ratio.height == ratio.width }
    
    public func path() -> UIBezierPath
    {
        return UIBezierPath(rect: CGRect(size: CGSize(width: 10 * ratio.width, height: 10 * ratio.height)))
    }
}

public class SuperEllipse: Shape
{
    var n: CGFloat = CGFloat.𝑒

    public func path() -> UIBezierPath
    {
        fatalError("implement")
    }
}

//MARK: - Drop

public class Drop : Shape
{
    public func path() -> UIBezierPath
    {
        return UIBezierPath(dropWithCenter: CGPointZero, radius: 10)
    }
}

extension UIBezierPath
{
    public convenience init(dropWithCenter center: CGPoint, radius: CGFloat)
    {
        self.init()
        
        let topPoint = CGPoint(x: 0, y: radius * 2)
        
        let topCtrlPoint = CGPoint(x: 0, y: radius)
        
        let leftCtrlPoint = CGPoint(x: -radius, y: radius * 0.75)
        let rightCtrlPoint = CGPoint(x: radius, y: radius * 0.75)
        
        moveToPoint(topPoint)
        
        addCurveToPoint(CGPoint(x: -radius, y: 0), controlPoint1: topCtrlPoint, controlPoint2: leftCtrlPoint)
        
        addArcWithCenter(CGPointZero, radius: radius, startAngle: π, endAngle: 0, clockwise: true)
        
        addCurveToPoint(topPoint, controlPoint1: rightCtrlPoint, controlPoint2: topCtrlPoint)
        
        closePath()
        
        applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
    }
    
    public func addDrop(center: CGPoint, radius: CGFloat)
    {
        appendPath(UIBezierPath(dropWithCenter: center, radius: radius))
    }
}

//MARK: - Star

extension UIBezierPath
{
    public convenience init(starWithCenter center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        spikes: Int)
    {
        self.init()
        
        guard spikes > 2 else { return }
        
        let angle = π / CGFloat(spikes)
        
        var radius = (outerRadius, innerRadius)
        
        moveToPoint(CGPoint(x: radius.0, y: 0))
        
        for _ in 0..<spikes*2
        {
            applyTransform(CGAffineTransformMakeRotation(angle))
            
            swap(&radius.0, &radius.1)
            
            addLineToPoint(CGPoint(x: radius.0, y: 0))
        }
        
        applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
        
        closePath()
    }
    
    public func addStar(center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        spikes: Int)
    {
        appendPath(UIBezierPath(starWithCenter: center, innerRadius: innerRadius, outerRadius: outerRadius, spikes: spikes))
    }
}


