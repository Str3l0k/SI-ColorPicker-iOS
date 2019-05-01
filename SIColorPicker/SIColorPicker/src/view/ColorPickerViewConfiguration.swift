import UIKit

// ColorPickerView configuration functions
extension ColorPickerView {
    internal func addSubViews() {
        addSubview(saturationThumbView)
        addSubview(brightnessThumbView)
        addSubview(colorGradientImageView)
        addSubview(colorSelectionThumbView)
        addSubview(colorPreviewView)
        addSubview(magnificationImage)
    }
    
    internal func initColorThumbControlView() {
        // actual view
        colorSelectionThumbView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        colorSelectionThumbView.backgroundColor = UIColor.clear
        
        // shape + layer
        let circlePath = UIBezierPath(ovalIn: colorSelectionThumbView.frame)
        colorSelectionThumbColorLayer.path = circlePath.cgPath
        colorSelectionThumbColorLayer.fillColor = UIColor.red.cgColor
        colorSelectionThumbColorLayer.strokeColor = lineColor.cgColor
        colorSelectionThumbColorLayer.lineWidth = 2

        // add shadow
        colorSelectionThumbColorLayer.shadowPath = circlePath.cgPath
        colorSelectionThumbColorLayer.shadowRadius = 3
        colorSelectionThumbColorLayer.shadowOffset = CGSize(width: 1, height: 1.5)
        colorSelectionThumbColorLayer.shadowColor = UIColor.darkGray.cgColor
        colorSelectionThumbColorLayer.shadowOpacity = 1

        colorSelectionThumbView.layer.insertSublayer(colorSelectionThumbColorLayer, at: 0)
    }
    
    internal func initColorPreviewView() {
        // actual view
        colorPreviewView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        colorPreviewView.backgroundColor = UIColor.clear
        
        // shape + layer
        let circlePath = UIBezierPath(ovalIn: colorPreviewView.bounds)
        colorPreviewLayer.path = circlePath.cgPath
        colorPreviewLayer.fillColor = UIColor.red.cgColor
        colorPreviewLayer.strokeColor = lineColor.cgColor
        colorPreviewLayer.lineWidth = 2

        colorPreviewView.layer.addSublayer(colorPreviewLayer)
    }
    
    internal func initMagnificationIcon() {
        magnificationImage.tintColor = UIColor.white
        magnificationImage.frame = colorPreviewView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        magnificationImage.center = bounds.center
        magnificationImage.alpha = 0.75
    }
    
    internal func initSaturationControl() {
        // thumb view
        saturationThumbView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        saturationThumbView.backgroundColor = UIColor.clear
        
        let thumbLayer = CAShapeLayer()
        thumbLayer.path = UIBezierPath(ovalIn: saturationThumbView.frame).cgPath
        thumbLayer.fillColor = UIColor.white.cgColor
        thumbLayer.shadowPath = thumbLayer.path
        thumbLayer.shadowColor = UIColor.darkGray.cgColor
        thumbLayer.shadowOpacity = 1
        thumbLayer.shadowRadius = 2
        thumbLayer.shadowOffset = CGSize(width: 1, height: 1)
        saturationThumbView.layer.addSublayer(thumbLayer)
        
        // gradient layer
        saturationLayer.startPoint = CGPoint(x: 0, y: 0.5)
        saturationLayer.endPoint = CGPoint(x: 1, y: 0.5)
        saturationLayer.colors = [UIColor.white.cgColor, UIColor.red.cgColor,]
        saturationLayer.mask = saturationMaskLayer
        
        // shape path mask layer
        saturationMaskLayer.fillColor = UIColor.clear.cgColor
        saturationMaskLayer.strokeColor = UIColor.black.cgColor
        saturationMaskLayer.lineCap = .round
        saturationMaskLayer.lineWidth = circleGradientMid
        
        layer.addSublayer(saturationLayer)
    }
    
    internal func initBrightnessControl() {
        // thumb view
        brightnessThumbView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        brightnessThumbView.backgroundColor = UIColor.clear
        
        let thumbLayer = CAShapeLayer()
        thumbLayer.path = UIBezierPath(ovalIn: brightnessThumbView.frame).cgPath
        thumbLayer.fillColor = UIColor.white.cgColor
        thumbLayer.shadowPath = thumbLayer.path
        thumbLayer.shadowColor = UIColor.darkGray.cgColor
        thumbLayer.shadowOpacity = 1
        thumbLayer.shadowRadius = 2
        thumbLayer.shadowOffset = CGSize(width: 1, height: 1)
        brightnessThumbView.layer.addSublayer(thumbLayer)
        
        // gradient layer
        brightnessLayer.startPoint = CGPoint(x: 0, y: 0.5)
        brightnessLayer.endPoint = CGPoint(x: 1, y: 0.5)
        brightnessLayer.colors = [UIColor.black.cgColor, UIColor.red.cgColor]
        brightnessLayer.mask = brightnessMaskLayer
        
        // shape path mask layer
        brightnessMaskLayer.fillColor = UIColor.clear.cgColor
        brightnessMaskLayer.strokeColor = UIColor.black.cgColor
        brightnessMaskLayer.lineCap = .round
        brightnessMaskLayer.lineWidth = circleGradientMid
        
        layer.addSublayer(brightnessLayer)
    }
}
