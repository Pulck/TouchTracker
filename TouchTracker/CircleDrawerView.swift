//
//  CircleDrawerView.swift
//  TouchTracker
//
//  Created by Colick on 2017/11/15.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreGraphics

class CircleDrawerView: UIView {
    
    var circles = [CGRect]()
    var currentCircle: CGRect?
    
    override func draw(_ rect: CGRect) {
        
        UIColor.red.setStroke()
        if let circle = currentCircle {
            drawCircle(circle)
        }
        
        UIColor.black.setStroke()
        circles.forEach { circle in
            drawCircle(circle)
        }
       
    }
    
    func drawCircle(_ circle: CGRect) {
        let path = UIBezierPath()
        path.addArc(withCenter: circle.origin, radius: circle.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentCircle = generateCircle(container: touches.reversed())
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentCircle = generateCircle(container: touches.reversed())
        
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        if let circle = currentCircle {
            circles.append(circle)
        }
        currentCircle = nil

        setNeedsDisplay()
    }
    
    func generateCircle(container: [UITouch]) -> CGRect? {
        print(container.count)
        guard container.count == 2 else {
            return currentCircle
        }
        let location1 = container[0].location(in: self)
        let location2 = container[1].location(in: self)
        
        let horizontalDistance = abs(location1.x - location2.x)
        let verticalDistance = abs(location1.y - location2.y)
        let diameter = min(horizontalDistance, verticalDistance)
        
        let originX = (location1.x + location2.x) / 2
        let originY = (location1.y + location2.y) / 2
        
        let circleBound = CGRect(x: originX, y: originY, width: diameter, height: diameter)
        return circleBound
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentCircle = nil
        setNeedsDisplay()
    }
}
