import Foundation

struct HomeViewModelMapper: Mappable {

    func mapObject(from objectToMap: [Course]) -> HomeViewModel {
        let courses = objectToMap
        let featured = Array(courses[..<4]).map { mapCourse($0) }
        let rest = Array(courses[4...]).map { mapCourse($0) }
        let viewModel = HomeViewModel(sections: [featured, rest])
        return viewModel
    }

    private func mapCourse(_ course: Course) -> CourseViewModel {
        var thumbnailUrl: URL?
        if let urlString = course.thumbnailUrl,
            let url = URL(string: urlString) {
            thumbnailUrl = url
        }

        let subtitleString = "de \(course.teacherName)"

        return CourseViewModel(
            id: course.id,
            title: course.title,
            subtitle: subtitleString,
            thumbnailUrl: thumbnailUrl)
    }
}
