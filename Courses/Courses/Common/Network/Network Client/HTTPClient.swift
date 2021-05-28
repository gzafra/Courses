import Foundation
import Combine
import Alamofire

enum HTTPClientError: Error {
    case incorrectRequest
    case noData
    case decodingFailed
    case alamofire(underlying: NSError?)
    case unknown
}

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol HTTPClient {
    func GET(_ definition: ApiDefinition) -> HTTPRequest
    func POST(_ definition: ApiDefinition) -> HTTPRequest
    func PUT(_ definition: ApiDefinition) -> HTTPRequest
    func PATCH(_ definition: ApiDefinition) -> HTTPRequest
    func DELETE(_ definition: ApiDefinition) -> HTTPRequest

    func execute<T: Decodable>(_ request: HTTPRequest, mapTo type: T.Type) -> Future<T, HTTPClientError>
}

class DefaultHTTPClient: HTTPClient {
    private let requestBuilder: URLRequestBuilder

    init(requestBuilder: URLRequestBuilder) {
        self.requestBuilder = requestBuilder
    }
    
    func GET(_ definition: ApiDefinition) -> HTTPRequest {
        DefaultHTTPRequest(method: .get, apiDefinition: definition)
    }
    func POST(_ definition: ApiDefinition) -> HTTPRequest {
        DefaultHTTPRequest(method: .post, apiDefinition: definition)
    }
    func PUT(_ definition: ApiDefinition) -> HTTPRequest {
        DefaultHTTPRequest(method: .put, apiDefinition: definition)
    }
    func PATCH(_ definition: ApiDefinition) -> HTTPRequest {
        DefaultHTTPRequest(method: .patch, apiDefinition: definition)
    }
    func DELETE(_ definition: ApiDefinition) -> HTTPRequest {
        DefaultHTTPRequest(method: .delete, apiDefinition: definition)
    }

    func execute<T: Decodable>(_ request: HTTPRequest,
                               mapTo type: T.Type) -> Future<T, HTTPClientError> {
        return Future { promise in
            self.executeRequest(request, mapTo: type) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let decodableResponse):
                        promise(.success(decodableResponse))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
    }

    private func executeRequest<T: Decodable>(_ requestToExecute: HTTPRequest,
                                              mapTo type: T.Type,
                                              completion: @escaping (Result<T, HTTPClientError>) -> Void) {
        guard let urlRequest = requestBuilder.build(with: requestToExecute) else {
            completion(.failure(HTTPClientError.incorrectRequest))
            return
        }

        AF.request(urlRequest).responseDecodable(of: type) { response in
            if let _ = response.data {
                guard let decodedResponse = response.value else {
                    completion(.failure(.decodingFailed))
                    return
                }
                completion(.success(decodedResponse))
            } else if let httpUrlResponse = response.response, (200...299) ~= httpUrlResponse.statusCode {
                completion(.failure(HTTPClientError.noData))
            } else {
                completion(.failure(self.map(error: response.error)))
            }
        }
    }

    private func map(error: AFError?) -> HTTPClientError {
        guard let afError = error as NSError? else { return .unknown }
        return .alamofire(underlying: afError)
    }
}
