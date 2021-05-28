import UIKit

enum Colors: Int, ColorAssets {
    case primaryFont = 0x1E1E1E
    case secondaryFont = 0x989898

    case beginner = 0xF5A623
    case intermediate = 0x0091FF
    case advanced = 0xE02020

    case hairline = 0xEEEEEE
}

protocol ColorAssets where Self: RawRepresentable, Self.RawValue == Int {}
extension ColorAssets {
    var color: UIColor {
        return UIColor(rgb: rawValue)
    }
}
