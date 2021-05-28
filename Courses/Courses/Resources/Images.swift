import UIKit

enum Images {

    enum Icons: String, ImageAssets {
        case audio
        case back
        case brand
        case subtitles
        case chevron
        case lesson
        case level
        case like
        case play
        case pause
        case replay
        case forward
        case search
        case students
        case share
    }
}

protocol ImageAssets where Self: RawRepresentable, Self.RawValue == String {}
extension ImageAssets {
    var image: UIImage? {
        guard let image = UIImage(named: rawValue) else {
            assertionFailure("Failed to load asset \(rawValue)")
            return nil
        }
        return image
    }
}
