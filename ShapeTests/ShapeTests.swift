//
//  ShapeTests.swift
//  ShapeTests
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Shape

class ShapeTests: XCTestCase
{
    func test_Polygon()
    {
        let p = Polygon(sides: 3)
        
        XCTAssertEqual(p.sides, 3)
        
        let path = p.pathForBounds(CGRect(x: 0, y: 0, width: 100, height: 100))
        
        XCTAssertFalse(path.empty)
    }
    
    func test_Equality()
    {
        let c = Circle()
        let e = Ellipse(ratio: (1,1))
        let p12 = Polygon(sides: 12)
        let t = Polygon(sides: 3)
        
        let shapes = [c, e, p12, t]
        
        for (i, s1) in shapes.enumerate()
        {
            for s2 in shapes[i+1..<shapes.count]
            {
                XCTAssertNotEqual(s1, s2)
            }
        }
    }
}
