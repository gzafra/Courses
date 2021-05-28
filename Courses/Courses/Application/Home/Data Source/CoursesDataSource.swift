import Foundation
import Combine

protocol CoursesDataSource {
    func getCourses() -> AnyPublisher<[Course], DomainError>
}

struct CoursesApiDataSource: CoursesDataSource {
    let httpClient: HTTPClient
    let mapper = CourseApiMapper()

    func getCourses() -> AnyPublisher<[Course], DomainError> {
        let apiDefinition = ApiDefinition(endpoint: .home)
        let request = httpClient.GET(apiDefinition)

        return httpClient.execute(request, mapTo: [CourseApiModel].self).mapError { (apiError) -> DomainError in
            // TODO: This mapping should be done by an error handler
            return DomainError.httpClient(underlying: apiError)
        }.map { apiModels -> [Course] in
            return self.mapper.mapObjects(from: apiModels)
        }.eraseToAnyPublisher()
    }   
}
