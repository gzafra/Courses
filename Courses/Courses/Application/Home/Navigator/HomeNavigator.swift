import UIKit

protocol HomeNavigator {
    func navigateToDetail(from view: HomeView, with course: Course)
}

struct DefaultHomeNavigator: HomeNavigator {

    let detailRouter: CourseDetailRouter

    func navigateToDetail(from view: HomeView, with course: Course) {
        let detailViewController = detailRouter.setupModule(with: course)
        guard let nc = (view as? UIViewController)?.navigationController else { return }
        nc.setNavigationBarHidden(false, animated: false)
        nc.pushViewController(detailViewController, animated: true)
    }
}
