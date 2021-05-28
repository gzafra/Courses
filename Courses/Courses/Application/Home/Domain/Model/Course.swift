import Foundation

struct Course {
    let id: String
    let title: String
    let thumbnailUrl: String?
    let description: String
    let teacherName: String
    let teacherAvatarUrl: String?
    let teacherLocation: String
    let trailerUrl: String?
    let positiveReviews: Int
    let totalReviews: Int
    let lessonsCount: Int
    let students: Int
    let audioLanguage: String
    let subtitles: [String]

    let level: CourseLevel?
}

enum CourseLevel {
    case beginner
    case intermediate
    case advanced
}
