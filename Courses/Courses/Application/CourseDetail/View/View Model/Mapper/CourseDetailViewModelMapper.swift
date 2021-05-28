import UIKit

struct CourseDetailViewModelMapper: Mappable {
    func mapObject(from objectToMap: Course) -> CourseDetailViewModel {
        return CourseDetailViewModel(
            thumbnailUrl: parseUrl(from: objectToMap.thumbnailUrl),
            title: objectToMap.title,
            description: objectToMap.description,
            teacherName: objectToMap.teacherName,
            teacherLocation: objectToMap.teacherLocation,
            teacherAvatarUrl: parseUrl(from: objectToMap.teacherAvatarUrl),
            previewUrl: parseUrl(from: objectToMap.trailerUrl),
            detailItems: parseDetailItems(from: objectToMap))
    }

    private func parseUrl(from urlString: String?) -> URL? {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
            else { return nil }
        return url
    }

    private func parseDetailItems(from model: Course) -> [DetailItemViewModel] {
        var items = [DetailItemViewModel]()

        items.append(getReviewsItem(positive: model.positiveReviews, total: model.totalReviews))
        items.append(getLessonsItem(numberOfLessons: model.lessonsCount))
        items.append(getStudentsItem(students: model.students))
        items.append(getAudioItem(language: model.audioLanguage))
        items.append(getSubtitlesItem(subtitles: model.subtitles))

        if let level = model.level {
            items.append(getLevelItem(level: level))
        }

        return items
    }

    private func getReviewsItem(positive: Int, total: Int) -> DetailItemViewModel {
        let percent = Int(round((Double(positive) / Double(total)) * 100.0))
        return DetailItemViewModel(
            icon: Images.Icons.like.image,
            title: "\(percent)% Positive reviews (\(total))"
        )
    }

    private func getLessonsItem(numberOfLessons: Int) -> DetailItemViewModel {
        return DetailItemViewModel(
            icon: Images.Icons.lesson.image,
            title: "\(numberOfLessons) Lessons"
        )
    }

    private func getStudentsItem(students: Int) -> DetailItemViewModel {
        return DetailItemViewModel(
            icon: Images.Icons.students.image,
            title: "\(students) Students"
        )
    }

    private func getAudioItem(language: String) -> DetailItemViewModel {
        return DetailItemViewModel(
            icon: Images.Icons.audio.image,
            title: "Audio: \(language)"
        )
    }

    private func getSubtitlesItem(subtitles: [String]) -> DetailItemViewModel {
        return DetailItemViewModel(
            icon: Images.Icons.subtitles.image,
            title: subtitles.joined(separator: " / ")
        )
    }

    private func getLevelItem(level: CourseLevel) -> DetailItemViewModel {
        return DetailItemViewModel(
            icon: Images.Icons.level.image,
            title: "Nivel",
            badge: DetailItemBadgeViewModel(title: level.title, color: level.color)
        )
    }
}

private extension CourseLevel {
    var title: String {
        switch self {
        case .beginner:
            return "BEGINNER"
        case .intermediate:
            return "INTERMEDIATE"
        case .advanced:
            return "ADVANCED"
        }
    }

    var color: UIColor {
        switch self {
        case .beginner:
            return Colors.beginner.color
        case .intermediate:
            return Colors.intermediate.color
        case .advanced:
            return Colors.advanced.color
        }
    }
}
