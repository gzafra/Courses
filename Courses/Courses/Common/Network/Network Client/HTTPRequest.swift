import Foundation

protocol HTTPRequest {
    var method: HTTPRequestMethod { get }
    var apiDefinition: ApiDefinition { get }
    var urlParameters: [String: String?]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }

    mutating func addBody<T: Encodable>(encodableBody: T)
}

struct DefaultHTTPRequest: HTTPRequest {
    let method: HTTPRequestMethod
    let apiDefinition: ApiDefinition
    var urlParameters: [String : String?]?
    var headers: [String : String]?
    var body: Data?

    mutating func addBody<T: Encodable>(encodableBody: T) {
        body = try? JSONEncoder().encode(encodableBody)
    }
}
