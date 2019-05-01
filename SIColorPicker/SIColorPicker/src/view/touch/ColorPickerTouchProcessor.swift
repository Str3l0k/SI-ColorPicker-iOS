import UIKit

// MARK: - precalculated constants
internal let piDouble: CGFloat = CGFloat(2 * Double.pi)
internal let piAndThreeQuarterPi: CGFloat = .pi * 1.75
internal let piThreeQuarter: CGFloat = .pi * 0.75
internal let piHalf: CGFloat = .pi * 0.5
internal let piQuarter: CGFloat = .pi * 0.25

// MARK: - touch processor class
class ColorPickerTouchProcessor {
    
    internal let parentView: UIView
    
    init(view: UIView) {
        self.parentView = view
    }
    
    // MARK: - parameters
    internal var centerCircleDistanceRange: ClosedRange<CGFloat> = 0...0
    internal var colorCircleDistanceRange: ClosedRange<CGFloat> = 0...0
    internal var controlCircleDistanceRange: ClosedRange<CGFloat> = 0...0
    internal var saturationAngleRange: ClosedRange<CGFloat> = (0.5 * .pi)...(1.75 * .pi) // due to overflow, inverted range is used
    internal var brightnessAngleRange: ClosedRange<CGFloat> = (0.75 * .pi)...(1.25 * .pi)
    internal var hexTextBouds: CGRect = CGRect.zero
    
    // MARK: - current function
    private var touchPosition: TouchPosition?
    
    // MARK: - registerd functions
    var previewCallback: (() -> Void)?
    var colorSelectionCallback: ((_ angle: CGFloat, _ moving: Bool) -> Void)?
    var saturationCallback: ((_ saturation: CGFloat, _ angle: CGFloat, _ moving: Bool) -> Void)?
    var brightnessCallback: ((_ brightness: CGFloat, _ angle: CGFloat, _ moving: Bool) -> Void)?
    var hexFieldCallback: (() -> Void)?
    
    // MARK: - touch functions
    func touchBegin(_ touch: UITouch) {
        let touchPoint = touch.location(in: parentView)
        let position = findPosition(from: parentView.bounds.center, to: touchPoint)
        touchPosition = position
        
        consumeTouch()
    }
    
    func touchMoved(_ touch: UITouch) {
        consumeMove(touchPoint: touch.location(in: parentView))
    }
    
    func touchEnd(_ touch: UITouch) {
        consumeMove(touchPoint: touch.location(in: parentView))
        touchPosition = nil
    }
    
    // MARK: - touch processing
    private func findPosition(from: CGPoint, to: CGPoint) -> TouchPosition {
        let distance = calculateDistance(from: from, to: to)
        
        if colorCircleDistanceRange.contains(distance) {
            return .colorCircle(angle: calculateAngle(from: from, to: to))
        } else if centerCircleDistanceRange.contains(distance) {
            return .previewCircle
        } else if controlCircleDistanceRange.contains(distance) {
            return .controlCircle(mode: determineControlMode(from: from, to: to))
        } else if hexTextBouds.contains(to) {
            return .hexField
        } else {
            return .none
        }
    }
    
    private func consumeTouch() {
        guard let touchPosition = touchPosition else {
            return
        }
        
        switch touchPosition {
        case .previewCircle:
            previewCallback?()
            break
        case .hexField:
            hexFieldCallback?()
            break
        case .colorCircle(let angle):
            colorSelectionCallback?(angle, false)
            break
        case .controlCircle(let mode):
            switch mode {
            case .saturation(let angle):
                let saturation = calculateSaturationValue(for: angle)
                saturationCallback?(saturation, angle + piHalf, false)
                break
            case.brightness(let angle):
                let brightness = calculateBrightnessValue(for: angle)
                brightnessCallback?(brightness, angle + piHalf, false)
                break
            default:
                break
            }
        case .none:
            break
        }
    }
    
    private func consumeMove(touchPoint: CGPoint) {
        guard let touchPosition = touchPosition else {
            return
        }
        
        let angleRadians = calculateAngle(from: parentView.bounds.center, to: touchPoint)
        
        switch touchPosition {
        case .controlCircle(let mode):
            // TODO calculate saturation or brightness value
            switch mode {
            case .saturation:
                let saturation = calculateSaturationValue(for: angleRadians)
                saturationCallback?(saturation, angleRadians + piHalf, true)
                break
            case .brightness:
                let brightness = calculateBrightnessValue(for: angleRadians)
                brightnessCallback?(brightness, angleRadians + piHalf, true)
                break
            case .none:
                break
            }
            
            break
        case .colorCircle:
            colorSelectionCallback?(angleRadians, true)
            break
        default:
            break
        }
    }
}

// MARK: - helper functions
extension ColorPickerTouchProcessor {
    private func calculateDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDelta = to.x - from.x
        let yDelta = to.y - from.y
        let delta = (xDelta * xDelta) + (yDelta * yDelta)
        let distance = sqrt(delta)
        
        return distance
    }
    
    private func calculateAngle(from: CGPoint, to: CGPoint) -> CGFloat {
        let x = to.x - from.x
        let y = from.y - to.y
        
        let rad = atan2(y, x) - (piHalf)
        return rad < 0 ? piDouble + rad : rad
    }
    
    private func determineControlMode(from: CGPoint, to: CGPoint) -> TouchControlMode {
        let angle = calculateAngle(from: from, to: to)
        
        if !saturationAngleRange.contains(angle) {
            return .saturation(angle: angle)
        } else if brightnessAngleRange.contains(angle) {
            return .brightness(angle: angle)
        } else {
            return .none
        }
    }
    
    private func calculateSaturationValue(for radians: CGFloat) -> CGFloat {
        if (piQuarter...(.pi)).contains(radians) {
            return 0
        } else if ((.pi)...(piAndThreeQuarterPi)).contains(radians) {
            return 1
        } else if (0...(piQuarter)).contains(radians) {
            let value = 1 - (radians / (piQuarter))
            return value / 2
        } else if ((piAndThreeQuarterPi)...(piDouble)).contains(radians) {
            return (1 - (radians - piAndThreeQuarterPi) / piQuarter) / 2 + 0.5
        }
        
        return 0
    }
    
    private func calculateBrightnessValue(for radians: CGFloat) -> CGFloat {
        // TODO filter to big or too low angles
        let baseAngle = radians - piThreeQuarter
        return baseAngle / piHalf
    }
}
