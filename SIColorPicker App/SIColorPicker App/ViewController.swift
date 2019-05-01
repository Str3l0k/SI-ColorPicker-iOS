//
//  ViewController.swift
//  SIColorPicker App
//
//  Created by Sebastian on 11.03.19.
//  Copyright © 2019 Sebastian Barz. All rights reserved.
//

import UIKit
import SIColorPicker

class ViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorPickerStoryboard = UIStoryboard(name: "ColorPicker", bundle: Bundle(for: ColorPickerViewController.self))
        if let colorPickerViewController = colorPickerStoryboard.instantiateInitialViewController() {
            self.pushViewController(colorPickerViewController, animated: false)
        }
    }
}

