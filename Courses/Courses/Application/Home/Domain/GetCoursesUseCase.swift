import Foundation
import Combine

protocol GetCoursesUseCase {
    func getCourses() -> AnyPublisher<[Course], DomainError>
}

struct DefaultGetCoursesUseCase: GetCoursesUseCase {
    let dataSource: CoursesDataSource

    func getCourses() -> AnyPublisher<[Course], DomainError> {
        dataSource.getCourses()
    }
}
