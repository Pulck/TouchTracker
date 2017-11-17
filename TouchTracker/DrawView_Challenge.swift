//
//  DrawView_Challenge.swift
//  TouchTracker
//
//  Created by Colick on 2017/11/15.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit

class DrawView_Challenge: UIView {

    var currentLine = [NSValue : Line]()
    var finshedLine = [Line]()
    
    @IBInspectable
    var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = lineThickness
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    
    override func draw(_ rect: CGRect) {
        finshedLine.forEach { line in
            let originX = line.begin.x
            let originY = line.begin.y
            
            let endX = line.end.x
            let endY = line.end.y
            
            if originX >= endX {
                if originY >= endY {
                    UIColor.orange.setStroke()
                } else {
                    UIColor.yellow.setStroke()
                }
            } else {
                if originY >= endY {
                    UIColor.green.setStroke()
                } else {
                    UIColor.brown.setStroke()
                }
            }
            
            stroke(line)
        }
        
        currentLineColor.setStroke()
        currentLine.forEach{ (_, line) in
            stroke(line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        touches.forEach { touche in
            let location = touche.location(in: self)
            let key = NSValue(nonretainedObject: touche)
            self.currentLine[key] = Line(begin: location, end: location)
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        touches.forEach { touche in
            let location = touche.location(in: self)
            let key = NSValue(nonretainedObject: touche)
            self.currentLine[key]?.end = location
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        touches.forEach { touche in
            let location = touche.location(in: self)
            let key = NSValue(nonretainedObject: touche)
            if var line = self.currentLine[key] {
                line.end = location
                finshedLine.append(line)
            }
        }
        currentLine.removeAll()
        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLine.removeAll()
        setNeedsDisplay()
    }
}
