//
//  ViewController.swift
//  TouchTracker
//
//  Created by Colick on 2017/11/14.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var threeTouchSwipe: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension ViewController {
    @IBAction func selectColor(segue: UIStoryboardSegue) {
        if let colorPane = segue.source as? ColorPaneViewController,
            let drawView = view as? DrawView{
            drawView.finishedLineColor = colorPane.selectedColor
        }
    }
    
    @objc
    func threeTouchSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Recognizer a swipe")
        
        
    }
}

