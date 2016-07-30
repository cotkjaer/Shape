//
//  ShapeView.swift
//  Shape
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics
import Path

@IBDesignable
public class ImageBasedShapeView: UIView
{
    // MARK: - Shape
    public var shape: Shape? = Circle() { didSet { updatePath(); setNeedsLayout(shape != oldValue) } }
    
    // MARK: - Fill
    
    @IBInspectable
    public var fillColor: UIColor = UIColor.whiteColor() { didSet { setNeedsLayout(fillColor != oldValue) } }
    
    // MARK: - Stroke
    
    @IBInspectable
    public var strokeColor: UIColor = UIColor.clearColor() { didSet { setNeedsLayout(strokeColor != oldValue) } }
    
    @IBInspectable
    public var strokeWidth: CGFloat = 1 { didSet { setNeedsLayout(strokeWidth != oldValue) } }
    
    @IBInspectable
    public var strokeWidthRelative: Bool = false { didSet { setNeedsLayout(strokeWidthRelative != oldValue) } }

    @IBInspectable
    public var strokeLineJoinStyle: CGLineJoin = .Miter
        { didSet { setNeedsLayout(strokeLineJoinStyle != oldValue) } }
    
    // MARK: - Line Width
    
    private var lineWidth : CGFloat
        {
            let factor = strokeWidthRelative ? min(bounds.size.width, bounds.size.height) : 1
            
            let scale = UIScreen.mainScreen().scale
            
            return ceil(scale * strokeWidth * factor) / scale
    }
    
    func setNeedsLayout(needed: Bool)
    {
        guard needed else { return }

        setNeedsLayout()
    }
    
    override public var bounds : CGRect { didSet { setNeedsLayout(bounds != oldValue) } }
    
    override public var frame : CGRect { didSet { setNeedsLayout(bounds != oldValue) } }
    
    // MARK: - Init
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    let imageView = UIImageView()
    
    func setup()
    {
        imageView.contentMode = .ScaleAspectFit
        
        addSubview(imageView)
        
        setNeedsLayout(true)
    }
    
    private var path = UIBezierPath()
    
    func updatePath()
    {
        guard let shape = shape else { return }

        guard bounds.width > 0 && bounds.height > 0 else { return }

        path = shape.pathForBounds(bounds)
        path.lineWidth = lineWidth
        path.lineJoinStyle = strokeLineJoinStyle

        path.transformToFit(bounds)
        
        imageView.image = path.image(strokeColor:strokeColor, fillColor: fillColor)
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        updatePath()
        imageView.frame = bounds
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize
    {
        let shapeSize = path.strokeBounds.size
        
        guard shapeSize.height > 0 && shapeSize.width > 0 else { return size }
        
        let scale = min(bounds.width / shapeSize.width, bounds.height / shapeSize.height)
        
        return shapeSize * scale
    }
}

// MARK: - Hit Testing

extension ImageBasedShapeView
{
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        guard super.pointInside(point, withEvent: event) else { return false }
        
        return path.containsPoint(CGPoint(x: point.x, y: bounds.maxY - point.y))
    }
    
    public final override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        guard userInteractionEnabled && !hidden && alpha > 0.01 else { return nil }
        
        if pointInside(point, withEvent: event)
        {
            for subview in subviews.reverse()
            {
                if let hitTestView = subview.hitTest(convertPoint(point, toView: subview), withEvent: event)
                {
                    return hitTestView
                }
            }
            
            return self
        }
        
        return nil
    }
}


// MARK: - Interface Builder

extension ImageBasedShapeView
{
    override public func intrinsicContentSize() -> CGSize
    {
        guard let shape = shape else { return CGSize(100) }
        
        return shape.pathForBounds(CGRect(origin: CGPointZero, size: CGSize(100))).bounds.size
    }
    
    override public func prepareForInterfaceBuilder()
    {
        setup()
    }
}

// MARK: - CustomDebugStringConvertible

extension ImageBasedShapeView
{
    override public var debugDescription : String { return super.debugDescription + ", shape: \(shape), fill-color: \(fillColor), stroke-color: \(strokeColor)" }
    
    override public var description : String { return super.description + ", shape: \(shape), fill-color: \(fillColor), stroke-color: \(strokeColor)" }
}
