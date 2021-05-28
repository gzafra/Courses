import Foundation

protocol CourseDetailView: class {
    func configure(with viewModel: CourseDetailViewModel)
    func startVideo()
}
