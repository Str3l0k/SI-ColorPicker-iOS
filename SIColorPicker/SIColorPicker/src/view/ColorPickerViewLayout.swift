//
//  ColorPickerViewLayout.swift
//  Cosprops App
//
//  Created by Sebastian on 11.10.18.
//  Copyright © 2018 Sebastian Barz. All rights reserved.
//

import UIKit

// MARK: - subview layouting
extension ColorPickerView {
    override func layoutSubviews() {
        guard !animating else {
            return
        }
        
        super.layoutSubviews()
        
        layoutColorGradient()
        positionColorPreview()
        positionMaginficationIcon()
        configureTouchProcessor()
        
        colorCircleRadius = colorGradientImageView.bounds.width / 2 - circleGradientMid
        controlCircleRadius = bounds.height / 2 - circleGradientMid
        
        positionColorSelectionThumbControlView()
        layoutSaturationControl()
        layoutBrightnessControl()
        
        self.preview = defaultPreview
    }
    
    // MARK: - sub item layout
    private func layoutColorGradient() {
        let circleHeight = calculateColorGradientSize()
        colorGradientImageView.frame = CGRect(x: 0, y: 0, width: circleHeight, height: circleHeight)
        colorGradientImageView.center = bounds.center
    }
    
    private func positionColorSelectionThumbControlView() {
        let x = bounds.centerX
        let y = colorGradientImageView.frame.minY + circleGradientMid
        
        colorSelectionThumbView.center = CGPoint(x: x, y: y)
        colorSelectionThumbView.alpha = defaultPreview ? 0 : 1
        
        let colorPositionAngle = calculateColorAngle(self.hsbColor.hue)
        positionColorControl(colorPositionAngle, false)
    }
    
    private func positionColorPreview() {
        colorPreviewView.center = bounds.center
        
        if defaultPreview {
            let scale = self.bounds.width / self.colorPreviewView.bounds.width
            self.colorPreviewView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.colorPreviewLayer.lineWidth = 2 / scale
        }
    }
    
    private func positionMaginficationIcon() {
        magnificationImage.center = bounds.center
    }
    
    private func layoutSaturationControl() {
        let arcStartAngle = rad(from: 45)
        
        // thumb view // TODO actual position
        let saturationAngle = calculateSaturationAngle(hsbColor.saturation)
        positionSaturationControl(hsbColor.saturation, saturationAngle, false)
        
        // shape path mask layer
        let topPath = UIBezierPath(arcCenter: bounds.center,
                                   radius: bounds.height / 2 - circleGradientMid,
                                   startAngle: -arcStartAngle,
                                   endAngle: .pi + arcStartAngle,
                                   clockwise: false)
        saturationMaskLayer.path = topPath.cgPath
        
        // gradient layer
        let topRect = CGRect(origin: bounds.topLeftCorner,
                             size: CGSize(width: frame.width,
                                          height: colorGradientImageView.frame.minY + actualGradientWidth))
        
        saturationLayer.frame = topRect
    }
    
    private func layoutBrightnessControl() {
        let arcStartAngle = rad(from: 45)
        
        // position thumb view
        let brightnessAngle = calculateBrightnessAngle(hsbColor.brightness)
        positionBrightnessControl(hsbColor.brightness, brightnessAngle, false)
        
        // shape path mask layer
        let bottomPath = UIBezierPath(arcCenter: bounds.center,
                                      radius: bounds.height / 2 - circleGradientMid,
                                      startAngle: arcStartAngle,
                                      endAngle: .pi - arcStartAngle,
                                      clockwise: true)
        brightnessMaskLayer.path = bottomPath.cgPath
        
        // gradient layer
        brightnessLayer.frame = bounds
    }
    
    private func configureTouchProcessor() {
        // center preview
        let previewRadius = colorPreviewView.frame.width / 2
        touchProcessor.centerCircleDistanceRange = 0...previewRadius
        
        // color selection
        let outerRadius = (colorGradientImageView.bounds.width / 2) + 30
        let innerRadius = (colorGradientImageView.bounds.width / 2) - 45
        
        touchProcessor.colorCircleDistanceRange = innerRadius...outerRadius
        
        // control radius
        let controlRadius = (bounds.height / 2 - circleGradientMid)
        let controlInnerRadius = controlRadius - 20
        let controlOuterRadius = controlRadius + 30
        
        touchProcessor.controlCircleDistanceRange = controlInnerRadius...controlOuterRadius
    }
    
    // MARK: - additional helper functions
    private func calculateColorGradientSize() -> CGFloat {
        return bounds.height * 0.66
    }
}
