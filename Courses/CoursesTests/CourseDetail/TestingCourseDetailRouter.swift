import Foundation
import UIKit
import Combine

@testable import Courses

class TestingCourseDetailRouter: DefaultCourseDetailRouter {
    var viewMock = CourseDetailViewMock()

    override func getPresenter(with course: Course) -> DefaultCourseDetailPresenter {
        let presenter = DefaultCourseDetailPresenter(with: course)
        presenter.view = viewMock
        return presenter
    }

}

class CourseDetailViewMock: CourseDetailView {

    var invokedConfigure = false
    var invokedConfigureCount = 0
    var invokedConfigureParameters: (viewModel: CourseDetailViewModel, Void)?
    var invokedConfigureParametersList = [(viewModel: CourseDetailViewModel, Void)]()

    func configure(with viewModel: CourseDetailViewModel) {
        invokedConfigure = true
        invokedConfigureCount += 1
        invokedConfigureParameters = (viewModel, ())
        invokedConfigureParametersList.append((viewModel, ()))
    }

    var invokedStartVideo = false
    var invokedStartVideoCount = 0

    func startVideo() {
        invokedStartVideo = true
        invokedStartVideoCount += 1
    }
}
