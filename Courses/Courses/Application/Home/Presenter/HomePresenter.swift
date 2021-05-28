import Foundation
import Combine

protocol HomePresenter: class {
    var view: HomeView? { get set }
    func viewDidLoad()
    func didTapCourse(with id: String)
}

class DefaultHomePresenter: HomePresenter {
    weak var view: HomeView?
    private var courses = [Course]()
    private let getCoursesUseCase: GetCoursesUseCase
    private var subscriptions: Set<AnyCancellable> = []
    private let viewModelMapper = HomeViewModelMapper()
    private let navigator: HomeNavigator

    init(getCoursesUseCase: GetCoursesUseCase,
         navigator: HomeNavigator) {
        self.getCoursesUseCase = getCoursesUseCase
        self.navigator = navigator
    }

    func viewDidLoad() {
        view?.setIsLoading(loading: true)
        getCoursesUseCase.getCourses().map({ (courses) -> HomeViewModel in
            self.courses = courses
            return self.viewModelMapper.mapObject(from: courses)
        }).sink(receiveCompletion: { (completion) in
            self.handle(completion: completion)
        }) { (viewModel) in
            self.view?.configure(with: viewModel)
        }.store(in: &subscriptions)
    }

    func handle(completion: Subscribers.Completion<DomainError>) {
        view?.setIsLoading(loading: false)
        switch completion {
        case .failure(let error):
            view?.displayError(message: error.localizedDescription)
        default:
            return
        }
    }

    func didTapCourse(with id: String) {
        guard
            let course = courses.first(where: { $0.id == id }),
            let view = view else { return }
        navigator.navigateToDetail(from: view, with: course)
    }
}
