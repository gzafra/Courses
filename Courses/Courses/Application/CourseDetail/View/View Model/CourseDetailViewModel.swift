import UIKit

struct CourseDetailViewModel {
    let thumbnailUrl: URL?
    let title: String
    let description: String
    let teacherName: String
    let teacherLocation: String
    let teacherAvatarUrl: URL?
    let previewUrl: URL?
    let detailItems: [DetailItemViewModel]
}

struct DetailItemViewModel {
    let icon: UIImage?
    let title: String
    var badge: DetailItemBadgeViewModel?
}

struct DetailItemBadgeViewModel {
    let title: String
    let color: UIColor
}
