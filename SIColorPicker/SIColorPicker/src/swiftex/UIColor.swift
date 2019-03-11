//
//  UIColor.swift
//  Cosprops Dash
//
//  Created by Sebastian on 23.08.18.
//  Copyright © 2018 Sebastian Barz. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - app colors
    static let primary: UIColor = UIColor(red:0.00, green:0.45, blue:0.61, alpha:1.0)
    
    static let accent: UIColor = UIColor(red:1.00, green:0.67, blue:0.25, alpha:1.0)
    
    static let error: UIColor = UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0)
    
    // MARK: - task colors
    static let none = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
    static let low = UIColor(red:0.22, green:0.56, blue:0.24, alpha:1.0)
    static let medium = UIColor(red:0.96, green:0.49, blue:0.00, alpha:1.0)
    static var high = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
    
    static let lightBackground = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
    
    var contrastFontColor: UIColor {
        var red = CGFloat(0), green = CGFloat(0), blue = CGFloat(0), alpha = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        
        if (luminance > 0.5) {
            return UIColor.black // bright colors - black font
        } else {
            return UIColor.white  // dark colors - white font
        }
    }
    
    var hexString: String {
        var red = CGFloat(0), green = CGFloat(0), blue = CGFloat(0), alpha = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let redI = Int((red * 255).rounded())
        let greenI = Int((green * 255).rounded())
        let blueI = Int((blue * 255).rounded())
        
        return String(format:"%02X%02X%02X", redI, greenI, blueI)
    }
    
    static func parse(hexWithPrefix string: String) -> UIColor? {
        guard string.count == 7, string.hasPrefix("#") else {
            return nil
        }
        
        return parse(hex: String(string.dropFirst()))
    }
    
    static func parse(hex string: String) -> UIColor? {
        guard string.count == 6 else {
            return nil
        }
        
        let values = string.split(by: 2)
        let colorValues = values.map { (value) -> CGFloat in
            return CGFloat(Int(value, radix: 16)! % 256) / 255
        }
        
        return UIColor(red: colorValues[0], green: colorValues[1], blue: colorValues[2], alpha: 1)
    }
}
