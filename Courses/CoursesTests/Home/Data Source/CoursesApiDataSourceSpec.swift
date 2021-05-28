import XCTest
import Nimble
import Combine

@testable import Courses

class CoursesApiDataSourceSpec: XCTestCase {

    private var sut: CoursesApiDataSource!
    private var httpClientMock: HTTPClientMock!
    private var subscriptions: Set<AnyCancellable> = []

    override func setUp() {
        httpClientMock = HTTPClientMock()
        httpClientMock.fixtureToLoad = "home"
        sut = CoursesApiDataSource(httpClient: httpClientMock)
    }

    override func tearDown() {
        httpClientMock = nil
        sut = nil
        subscriptions = []
    }

    func test_fetch_courses_succeed() {
        var received: [Course]?

        waitUntil(timeout: 0.6) { done in
            self.sut.getCourses().sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    done()
                case .failure:
                    fail()
                }
            }) { (response) in
                received = response
            }.store(in: &self.subscriptions)
        }

        expect(received).toNot(beNil())
        expect(received!.count).to(equal(11))
    }
}



