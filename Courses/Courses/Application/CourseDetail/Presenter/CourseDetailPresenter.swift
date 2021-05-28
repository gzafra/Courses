import Foundation
import Combine

protocol CourseDetailPresenter: class {
    var view: CourseDetailView? { get set }
    func viewDidLoad()
    func viewDidAppear()
}

class DefaultCourseDetailPresenter: CourseDetailPresenter {
    weak var view: CourseDetailView?
    private let course: Course
    private let viewModelMapper = CourseDetailViewModelMapper()

    init(with course: Course) {
        self.course = course
    }

    func viewDidLoad() {
        let viewModel = viewModelMapper.mapObject(from: course)
        self.view?.configure(with: viewModel)
    }

    func viewDidAppear() {
        self.view?.startVideo()
    }
}
