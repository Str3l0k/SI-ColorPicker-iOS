//
//  Math.swift
//  SIColorPicker
//
//  Created by Sebastian on 11.03.19.
//  Copyright © 2019 Sebastian Barz. All rights reserved.
//

import Foundation

func degrees(from rad: CGFloat) -> CGFloat {
    return rad * 180 / .pi
}

func rad(from deg: CGFloat) -> CGFloat {
    return deg * .pi / 180
}
