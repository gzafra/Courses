import Foundation

enum DomainError: Error {
    case httpClient(underlying: HTTPClientError)
    case generic
}
