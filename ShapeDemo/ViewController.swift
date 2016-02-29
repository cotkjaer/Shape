//
//  ViewController.swift
//  ShapeDemo
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Shape

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        polygonViews.forEach({ $0.sizeToFit() })
    }
    
    @IBOutlet var polygonViews: [PolygonView]!

}

