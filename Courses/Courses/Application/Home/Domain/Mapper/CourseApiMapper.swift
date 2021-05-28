import Foundation

struct CourseApiMapper: Mappable {

    func mapObject(from objectToMap: CourseApiModel) -> Course {
        return Course(
            id: objectToMap.id,
            title: objectToMap.title,
            thumbnailUrl: objectToMap.thumbnailUrl,
            description: objectToMap.description,
            teacherName: objectToMap.teacher.name,
            teacherAvatarUrl: objectToMap.teacher.avatarUrl,
            teacherLocation: objectToMap.location,
            trailerUrl: objectToMap.trailerUrl,
            positiveReviews: objectToMap.reviews.positive,
            totalReviews: objectToMap.reviews.total,
            lessonsCount: objectToMap.lessonsCount,
            students: objectToMap.students,
            audioLanguage: objectToMap.audio,
            subtitles: objectToMap.subtitles,
            level: mapCourseLevel(from: objectToMap.level))
    }

    private func mapCourseLevel(from string: String) -> CourseLevel? {
        switch string {
        case "Beginner":
            return .beginner
        case "Intermediate":
            return .intermediate
        case "Advanced":
            return .advanced
        default:
            return nil
        }

    }
}
