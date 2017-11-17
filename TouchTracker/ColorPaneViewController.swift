//
//  ColorPaneViewController.swift
//  TouchTracker
//
//  Created by Colick on 2017/11/17.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit

class ColorPaneViewController: UIViewController {

    var selectedColor: UIColor!
    
    @IBAction func changeSelectedColor(_ sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
