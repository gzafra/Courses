
import Foundation

struct CoursesApiResponse: Decodable {
    let courses: [CourseApiModel]
}

struct CourseApiModel: Decodable {
    let id: String
    let thumbnailUrl: String?
    let title: String
    let description: String
    let trailerUrl: String?
    let location: String
    let teacher: TeacherApiModel
    let reviews: ReviewsApiModel
    let lessonsCount: Int
    let students: Int
    let audio: String
    let subtitles: [String]
    let level: String
}

struct TeacherApiModel: Decodable {
    let name: String
    let avatarUrl: String?
}

struct ReviewsApiModel: Decodable {
    let positive: Int
    let total: Int
}
