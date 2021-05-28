import Foundation
import UIKit

protocol CourseDetailRouter {
    func setupModule(with course: Course) -> UIViewController
}

class DefaultCourseDetailRouter: CourseDetailRouter {
    func setupModule(with course: Course) -> UIViewController {
        let presenter = getPresenter(with: course)
        let view = CourseDetailViewController(presenter: presenter)
        return view
    }

    func getPresenter(with course: Course) -> DefaultCourseDetailPresenter {
        let presenter = DefaultCourseDetailPresenter(with: course)
        return presenter
    }

}
