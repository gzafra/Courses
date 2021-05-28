import Foundation
import UIKit
import Combine

@testable import Courses

class TestingHomeRouter: DefaultHomeRouter {
    var observingUseCase: GetCoursesUseCase!
    var homeViewMock = HomeViewMock()
    var shouldFailRequest: Bool = false

    override func getHomePresenter() -> HomePresenter {
        let presenter = DefaultHomePresenter(getCoursesUseCase: getCoursesUseCase(),
                                             navigator: getHomeNavigator())
        presenter.view = homeViewMock
        return presenter
    }

    override func getCoursesUseCase() -> GetCoursesUseCase {
        let getCoursesUseCase = DefaultGetCoursesUseCase(dataSource: getCoursesDataSource())
        observingUseCase = getCoursesUseCase
        return getCoursesUseCase
    }

    override func getHTTPClient() -> HTTPClient {
        let httpClientMock = HTTPClientMock()
        httpClientMock.fixtureToLoad = "home"
        httpClientMock.shouldFailRequest = shouldFailRequest
        return httpClientMock
    }
}

class HomeViewMock: HomeView {

    var invokedConfigure = false
    var invokedConfigureCount = 0
    var invokedConfigureParameters: (viewModel: HomeViewModel, Void)?
    var invokedConfigureParametersList = [(viewModel: HomeViewModel, Void)]()

    func configure(with viewModel: HomeViewModel) {
        invokedConfigure = true
        invokedConfigureCount += 1
        invokedConfigureParameters = (viewModel, ())
        invokedConfigureParametersList.append((viewModel, ()))
    }

    var invokedDisplayError = false
    var invokedDisplayErrorCount = 0
    var invokedDisplayErrorParameters: (message: String, Void)?
    var invokedDisplayErrorParametersList = [(message: String, Void)]()

    func displayError(message: String) {
        invokedDisplayError = true
        invokedDisplayErrorCount += 1
        invokedDisplayErrorParameters = (message, ())
        invokedDisplayErrorParametersList.append((message, ()))
    }

    var invokedSetIsLoading = false
    var invokedSetIsLoadingCount = 0
    var invokedSetIsLoadingParameters: (loading: Bool, Void)?
    var invokedSetIsLoadingParametersList = [(loading: Bool, Void)]()

    func setIsLoading(loading: Bool) {
        invokedSetIsLoading = true
        invokedSetIsLoadingCount += 1
        invokedSetIsLoadingParameters = (loading, ())
        invokedSetIsLoadingParametersList.append((loading, ()))
    }
}
