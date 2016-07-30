//
//  ShapeViewController.swift
//  Shape
//
//  Created by Christian Otkjær on 29/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Shape

class ShapeViewController: UIViewController
{
    var shapes : [Shape] = [Polygon(sides: 6), SuperEllipse(), Polygon(sides: 3), Drop(), Ellipse(ratio: (3,2)), Rectangle(ratio: (1,7)), Star(spikes: 15), Polygon(sides: 4), Heart(), Circle()]
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    
        if shapeView?.shape == nil
        {
            shapeView?.shape = shapes.removeFirst()
        }
    }
    
    @IBAction func handleBorderWidthSlider(slider: UISlider)
    {
        guard let shapeView = shapeView else { return }
        
        let value = CGFloat(round(slider.value * 100))
        
        let currentValue = round(shapeView.strokeWidth * 100)
        
        if shapeView.strokeWidthRelative
        {
            if value != currentValue
            {
                shapeView.strokeWidth = value / 100
            }
        }
        else
        {
            shapeView.shapeRotation = CGFloat(Double(slider.value) * M_PI * 2)
        }
    }
    
    @IBAction func handleButton(sender: UIButton)
    {
        let color = sender.backgroundColor ?? UIColor.blackColor()
        
        shapeView?.fillColor = color
    }
    
    @IBAction func handleShapeTapped(tap: UITapGestureRecognizer)
    {
        guard tap.state == .Ended else { return }

        guard let shapeView = tap.view as? ShapeView else { return }
        
        shapes.append(shapeView.shape)
        UIView.animateWithDuration(0.25)
        {
            shapeView.shape = self.shapes.removeFirst()
        }
        view.setNeedsUpdateConstraints()

        UIView.animateWithDuration(0.25)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    var shapeView : ShapeView? { return view.subviews.find(ShapeView) }
}
