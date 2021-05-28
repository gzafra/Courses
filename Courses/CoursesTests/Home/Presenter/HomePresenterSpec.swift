import XCTest
import Nimble
import Combine

@testable import Courses

class HomePresenterSpec: XCTestCase {

    private var sut: DefaultHomePresenter!
    private var homeViewMock: HomeViewMock! {
        testingRouter.homeViewMock
    }
    private var testingRouter = TestingHomeRouter()

    func test_didLoad() {
        givenRequestSucceeds()
        sut.viewDidLoad()
        expect(self.homeViewMock.invokedConfigure).to(beTrue())
        let viewModel = self.homeViewMock.invokedConfigureParameters?.viewModel
        expect(viewModel).toNot(beNil())
        expect(viewModel!.numberOfSections).to(equal(2))
        expect(self.homeViewMock.invokedDisplayError).to(beFalse())
    }

    func test_didLoad_failed() {
        givenRequestFails()
        sut.viewDidLoad()
        expect(self.homeViewMock.invokedConfigure).to(beFalse())
        expect(self.homeViewMock.invokedDisplayError).to(beTrue())
    }

    private func givenRequestSucceeds() {
        testingRouter.shouldFailRequest = false
        sut = (testingRouter.getHomePresenter() as! DefaultHomePresenter)
    }

    private func givenRequestFails() {
        testingRouter.shouldFailRequest = true
        sut = (testingRouter.getHomePresenter() as! DefaultHomePresenter)
    }
}



