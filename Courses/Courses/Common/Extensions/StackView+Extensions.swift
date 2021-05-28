import UIKit

extension UIStackView {
    func removeArrangedSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
        arrangedSubviews.forEach { removeArrangedSubview($0) }
    }
}
