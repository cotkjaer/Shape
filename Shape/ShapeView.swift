//
//  ShapeView.swift
//  Shape
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Silverback

@IBDesignable
public class ShapeView: UIView
{
    public var shape: Shape = Drop() { didSet { setNeedsLayout() } }

    @IBInspectable
    public var fillColor: UIColor = UIColor.whiteColor() { didSet { shapeLayer.fillColor = fillColor.CGColor } }

    @IBInspectable
    public var strokeColor: UIColor = UIColor.whiteColor() { didSet { shapeLayer.strokeColor = strokeColor.CGColor } }
    
    override public var bounds : CGRect { didSet { setNeedsLayout() } }
    
    override public var frame : CGRect { didSet { setNeedsLayout() } }
    
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
    
    let shapeLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    func setup()
    {
        updateLayers()
        
        layer.mask = maskLayer
        
        layer.addSublayer(shapeLayer)
    }
    
    override public var backgroundColor: UIColor?
        {
        set { fillColor = newValue ?? UIColor.clearColor() }
        get { return UIColor.clearColor() }
    }
    
    func updateLayers()
    {
        shapeLayer.fillColor = fillColor.CGColor
        
        let path = shape.path(bounds)
        
        shapeLayer.path = path.CGPath
        
        maskLayer.path = path.CGPath
    }

    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        updateLayers()
    }
    
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        return super.pointInside(point, withEvent: event) && (shapeLayer.path?.contains(point) == true)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize
    {
        let shapeSize = shape.path().bounds.size
        
        let scale = min(bounds.width / shapeSize.width, bounds.height / shapeSize.height)

        return shapeSize * scale
    }
}

// MARK: - Interface Builder

extension ShapeView
{
    override public func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 100,height: 100) //shape.intrinsicContentSize()
        //        return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
    }
    
    override public func prepareForInterfaceBuilder()
    {
        setup()
    }
}

// MARK: - CustomDebugStringConvertible

extension ShapeView : CustomDebugStringConvertible
{
    override public var debugDescription : String { return super.debugDescription + ", shape: \(shape), color: \(fillColor)"  }
    
    override public var description : String { return super.description + ", shape: \(shape), color: \(fillColor)"  }
}

@IBDesignable
public class PolygonView : ShapeView
{
    @IBInspectable
    public var sides : Int = 3 { didSet { shape = Polygon(sides: sides) } }
    
    override func setup()
    {
        shape = Polygon(sides: sides)
        
        super.setup()
    }
}
