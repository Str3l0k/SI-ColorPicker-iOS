import Foundation

func degrees(from rad: CGFloat) -> CGFloat {
    return rad * 180 / .pi
}

func rad(from deg: CGFloat) -> CGFloat {
    return deg * .pi / 180
}
