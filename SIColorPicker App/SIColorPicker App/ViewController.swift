//
//  ViewController.swift
//  SIColorPicker App
//
//  Created by Sebastian on 11.03.19.
//  Copyright © 2019 Sebastian Barz. All rights reserved.
//

import UIKit
import SIColorPicker

class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorPickerStoryboard = UIStoryboard(name: "ColorPicker", bundle: nil)
        let colorPickerViewController = colorPickerStoryboard.instantiateInitialViewController()
        
        containerView.addSubview(colorPickerViewController!.view)
    }
}

