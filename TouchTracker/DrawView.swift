//
//  DrawView.swift
//  TouchTracker
//
//  Created by Colick on 2017/11/14.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit
import Foundation

class DrawView: UIView {
    
    var currentLine = [NSValue : Line]()
    var finshedLine = [Line]()
    var touchPoint: CGPoint?
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                UIMenuController.shared.setMenuVisible(false, animated: true)
            }
        }
    }
    
    @IBOutlet var colorPaneViewController: UIViewController!
    var moveRecognizer: UIPanGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressTecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPress(_:)))
        addGestureRecognizer(longPressTecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(moveLine(_:)))
        moveRecognizer.cancelsTouchesInView = false
        moveRecognizer.delegate = self
        addGestureRecognizer(moveRecognizer)
        
    }

    
    @IBInspectable
    var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var finishedLineColor: UIColor = UIColor.black {
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
        finishedLineColor.setStroke()
        for line in finshedLine {
            stroke(line)
        }
        
        currentLineColor.setStroke()
        currentLine.forEach{ (_, line) in
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            stroke(finshedLine[index])
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

extension DrawView {
    //MARK: Gesture and responsive action
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //Action for delete menu item
    @objc
    func deleteLine(_ sender: UIMenuController) {
        finshedLine.remove(at: selectedLineIndex!)
        selectedLineIndex = nil
        setNeedsDisplay()
    }
    
    //Action for double tap gesture
    @objc
    func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognizer a double tap")
        currentLine.removeAll()
        finshedLine.removeAll()
        selectedLineIndex = nil
        setNeedsDisplay()
    }
    
    //Action for tap gesture
    @objc
    func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognizer a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        touchPoint = point
        
        let menuController = UIMenuController.shared
        if selectedLineIndex != nil {
            self.becomeFirstResponder()
            if menuController.menuItems == nil {
                let deleteItem = UIMenuItem(title: "delete", action: #selector(deleteLine(_:)))
                menuController.menuItems = [deleteItem]
            }
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menuController.setTargetRect(targetRect, in: self)
            menuController.setMenuVisible(true, animated: true)
        } else {
            menuController.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    //Action for press gesture
    @objc
    func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognizer a long press")
        
        switch gestureRecognizer.state {
        case .began:
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
        case .ended:
            selectedLineIndex = nil
        default:
            break
        }
        
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finshedLine.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0.0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20 {
                    return index
                }
            }
        }
        return nil
    }
    
    //Action for move gesture
    @objc
    func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognizer a pan")
        
        if let index = selectedLineIndex,
            UIMenuController.shared.isMenuVisible != true {
            switch gestureRecognizer.state {
            case .began:
                fallthrough
            case .changed:
                let translation = gestureRecognizer.translation(in: self)
                finshedLine[index].begin.x +=	 translation.x
                finshedLine[index].begin.y += translation.y
                finshedLine[index].end.x += translation.x
                finshedLine[index].end.y += translation.y
                gestureRecognizer.setTranslation(.zero, in: self)
                setNeedsDisplay()
            default:
                break
            }
        } else {
            selectedLineIndex = nil
        }
    }
    
}

extension DrawView: UIGestureRecognizerDelegate {
    //MARK: - UI gesture recognizer delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
