import Foundation

protocol HomeView: class {
    func configure(with viewModel: HomeViewModel)
    func displayError(message: String)
    func setIsLoading(loading: Bool)
}
