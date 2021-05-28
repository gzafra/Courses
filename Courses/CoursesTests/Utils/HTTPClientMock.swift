import Foundation
import Combine

@testable import Courses

class HTTPClientMock: HTTPClient {

    var fixtureToLoad: String?
    var shouldFailRequest = false

    var invokedGET = false
    var invokedGETCount = 0
    var invokedGETParameters: (definition: ApiDefinition, Void)?
    var invokedGETParametersList = [(definition: ApiDefinition, Void)]()
    var stubbedGETResult: HTTPRequest!

    func GET(_ definition: ApiDefinition) -> HTTPRequest {
        invokedGET = true
        invokedGETCount += 1
        invokedGETParameters = (definition, ())
        invokedGETParametersList.append((definition, ()))
        return stubbedGETResult ?? DefaultHTTPRequest(method: .get, apiDefinition: definition)
    }

    var invokedPOST = false
    var invokedPOSTCount = 0
    var invokedPOSTParameters: (definition: ApiDefinition, Void)?
    var invokedPOSTParametersList = [(definition: ApiDefinition, Void)]()
    var stubbedPOSTResult: HTTPRequest!

    func POST(_ definition: ApiDefinition) -> HTTPRequest {
        invokedPOST = true
        invokedPOSTCount += 1
        invokedPOSTParameters = (definition, ())
        invokedPOSTParametersList.append((definition, ()))
        return stubbedPOSTResult ?? DefaultHTTPRequest(method: .post, apiDefinition: definition)
    }

    var invokedPUT = false
    var invokedPUTCount = 0
    var invokedPUTParameters: (definition: ApiDefinition, Void)?
    var invokedPUTParametersList = [(definition: ApiDefinition, Void)]()
    var stubbedPUTResult: HTTPRequest!

    func PUT(_ definition: ApiDefinition) -> HTTPRequest {
        invokedPUT = true
        invokedPUTCount += 1
        invokedPUTParameters = (definition, ())
        invokedPUTParametersList.append((definition, ()))
        return stubbedPUTResult ?? DefaultHTTPRequest(method: .put, apiDefinition: definition)
    }

    var invokedPATCH = false
    var invokedPATCHCount = 0
    var invokedPATCHParameters: (definition: ApiDefinition, Void)?
    var invokedPATCHParametersList = [(definition: ApiDefinition, Void)]()
    var stubbedPATCHResult: HTTPRequest!

    func PATCH(_ definition: ApiDefinition) -> HTTPRequest {
        invokedPATCH = true
        invokedPATCHCount += 1
        invokedPATCHParameters = (definition, ())
        invokedPATCHParametersList.append((definition, ()))
        return stubbedPATCHResult ?? DefaultHTTPRequest(method: .patch, apiDefinition: definition)
    }

    var invokedDELETE = false
    var invokedDELETECount = 0
    var invokedDELETEParameters: (definition: ApiDefinition, Void)?
    var invokedDELETEParametersList = [(definition: ApiDefinition, Void)]()
    var stubbedDELETEResult: HTTPRequest!

    func DELETE(_ definition: ApiDefinition) -> HTTPRequest {
        invokedDELETE = true
        invokedDELETECount += 1
        invokedDELETEParameters = (definition, ())
        invokedDELETEParametersList.append((definition, ()))
        return stubbedDELETEResult ?? DefaultHTTPRequest(method: .delete, apiDefinition: definition)
    }

    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (request: HTTPRequest, type: Any)?
    var invokedExecuteParametersList = [(request: HTTPRequest, type: Any)]()
    var stubbedExecuteResult: Future<Any, HTTPClientError>!

    func execute<T: Decodable>(_ request: HTTPRequest, mapTo type: T.Type) -> Future<T, HTTPClientError> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (request, type)
        invokedExecuteParametersList.append((request, type))
        return Future { promise in
            if let fixtureToLoad = self.fixtureToLoad, !self.shouldFailRequest {
                let decodableResponse = JSONLoader.decodableFixture(type, from: fixtureToLoad)
                promise(.success(decodableResponse))
            } else {
                promise(.failure(HTTPClientError.unknown))
            }

        }
    }
}
