import UIKit

extension CGRect {
    var centerX: CGFloat {
        return (maxX - minX) / 2.0
    }
    
    var centerY: CGFloat {
        return (maxY - minY) / 2.0
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            let deltaX = newValue.x - origin.x
            let deltaY = newValue.y - origin.y
            
            self = offsetBy(dx: deltaX, dy: deltaY)
        }
    }
    
    
    
    
}

// MARK: - corners
extension CGRect {
    var topRightCorner: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    
    var topLeftCorner: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
}

// MARK: - edge middle points
extension CGRect {
    var leftMiddle: CGPoint {
        return CGPoint(x: minX, y: centerY)
    }
    
    var rightMiddle: CGPoint {
        return CGPoint(x: maxX, y: centerY)
    }
    
    var bottomMiddle: CGPoint {
        return CGPoint(x: centerX, y: maxY)
    }
}
