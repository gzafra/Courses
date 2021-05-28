import XCTest
import Nimble

@testable import Courses

class CourseDetailPresenterSpec: XCTestCase {

    private var sut: DefaultCourseDetailPresenter!
    private var viewModelMock: CourseDetailViewMock! {
        testingRouter.viewMock
    }
    private var testingRouter = TestingCourseDetailRouter()

    func test_didLoad() {
        sut = testingRouter.getPresenter(with: courseMock())
        sut.viewDidLoad()
        expect(self.viewModelMock.invokedConfigure).to(beTrue())
    }

    func test_didAppear() {
        sut = testingRouter.getPresenter(with: courseMock())
        sut.viewDidAppear()
        expect(self.viewModelMock.invokedStartVideo).to(beTrue())
    }

    func courseMock() -> Course {
        return Course(id: "",
                      title: "Title",
                      thumbnailUrl: nil,
                      description: "Description",
                      teacherName: "Teacher name",
                      teacherAvatarUrl: nil,
                      teacherLocation: "Barcelona, Spain",
                      trailerUrl: nil,
                      positiveReviews: 50,
                      totalReviews: 90,
                      lessonsCount: 10,
                      students: 100,
                      audioLanguage: "Spanish",
                      subtitles: [],
                      level: nil)
    }
}


