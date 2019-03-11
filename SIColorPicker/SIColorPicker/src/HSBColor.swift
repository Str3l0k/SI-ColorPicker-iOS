//
//  HSBColor.swift
//  Cosprops App
//
//  Created by Sebastian on 11.10.18.
//  Copyright © 2018 Sebastian Barz. All rights reserved.
//
import UIKit

struct HSBColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 1
    var brightness: CGFloat = 1
    var alpha: CGFloat = 1
    
    var uiColor: UIColor {
        get {
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness,
                           alpha: alpha)
        }
        mutating set {
            newValue.getHue(&hue,
                            saturation: &saturation,
                            brightness: &brightness,
                            alpha: &alpha)
            
            if saturation > 1 {
                saturation = 1
            } else if saturation < 0 {
                saturation = 0
            }
            
            if brightness > 1 {
                brightness = 1
            } else if brightness < 0 {
                brightness = 0
            }
            
            alpha = 1
        }
    }
    
    var baseColor: UIColor {
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
    }
}
