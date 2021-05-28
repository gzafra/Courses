import UIKit

typealias CourseCellAction = (() -> Void)

protocol CourseCell where Self: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    func configure(with course: CourseViewModel, action: @escaping CourseCellAction)
}

extension CourseCell {
    static var reuseIdentifier: String { String(describing: self) }
}
