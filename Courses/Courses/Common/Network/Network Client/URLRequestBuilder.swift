import Foundation

protocol URLRequestBuilder {
    func build(with httpRequest: HTTPRequest) -> URLRequest?
}

struct DefaultURLRequestBuilder: URLRequestBuilder {
    func build(with httpRequest: HTTPRequest) -> URLRequest? {
        guard var urlComponents = URLComponents(string: httpRequest.apiDefinition.baseURL) else { return nil }
        urlComponents.path = httpRequest.apiDefinition.endpoint.path

        if let queryParameters = httpRequest.urlParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = urlComponents.url else { return nil }

        var mutableRequest = URLRequest(url: url)

        if let headers = httpRequest.headers {
            headers.forEach { key, value in
                mutableRequest.addValue(
                    value,
                    forHTTPHeaderField: key
                )
            }
        }

        mutableRequest.httpBody = httpRequest.body
        mutableRequest.httpMethod = httpRequest.method.rawValue

        return mutableRequest
    }
}
