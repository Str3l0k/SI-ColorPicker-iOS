//
//  TouchPosition.swift
//  SIColorPicker
//
//  Created by Sebastian on 01.05.19.
//  Copyright © 2019 Sebastian Barz. All rights reserved.
//

import Foundation

enum TouchPosition {
    case controlCircle(mode: TouchControlMode)
    case colorCircle(angle: CGFloat)
    case hexField
    case previewCircle
    case none
}
