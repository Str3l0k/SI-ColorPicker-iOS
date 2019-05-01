import Foundation
import UIKit

extension UIColor {
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
