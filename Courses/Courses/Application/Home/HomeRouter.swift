import Foundation
import UIKit

protocol HomeRouter {
    func setupModule() -> UIViewController
}

class DefaultHomeRouter: HomeRouter {
    func setupModule() -> UIViewController {
        let presenter = getHomePresenter()
        let view = HomeViewController(presenter: presenter,
                                      collectionViewLayoutManager: getCollectionViewLayoutManager())
        let nc = UINavigationController(rootViewController: view)
        return nc
    }

    // MARK: - Presenter

    func getHomePresenter() -> HomePresenter {
        DefaultHomePresenter(getCoursesUseCase: getCoursesUseCase(),
                             navigator: getHomeNavigator())
    }

    // MARK: - Use Case

    func getCoursesUseCase() -> GetCoursesUseCase {
        DefaultGetCoursesUseCase(dataSource: getCoursesDataSource())
    }

    // MARK: - Data Source

    func getCoursesDataSource() -> CoursesDataSource {
        CoursesApiDataSource(httpClient: getHTTPClient())
    }

    // MARK: - Navigation

    func getHomeNavigator() -> HomeNavigator {
        DefaultHomeNavigator(detailRouter: DefaultCourseDetailRouter())
    }

    // MARK: - Others

    func getHTTPClient() -> HTTPClient {
        DefaultHTTPClient(requestBuilder: DefaultURLRequestBuilder())
    }

    func getCollectionViewLayoutManager() -> CollectionViewLayoutManager {
        HomeCollectionViewLayoutManager()
    }
}
