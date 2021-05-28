import XCTest
import Nimble

@testable import Courses

class URLRequestBuilder: XCTestCase {

    private var sut: DefaultURLRequestBuilder!
    private var testBody: TestBody!
    private var testHTTPRequest: HTTPRequest!

    override func setUp() {

        testBody = TestBody(bodyParam: "paramValue")
        sut = DefaultURLRequestBuilder()
    }

    override func tearDown() {
        sut = nil
    }

    func test_build_post_request() {
        givenAPostRequestWithBody()
        let request = sut.build(with: testHTTPRequest)

        expect(request).toNot(beNil())
        expect(request?.httpBody).toNot(beNil())
    }

    func test_build_get_request() {
        givenAGetRequestWithQueryParams()
        let request = sut.build(with: testHTTPRequest)

        expect(request).toNot(beNil())
        expect(request?.httpBody).to(beNil())
        expect(request?.url?.absoluteString).toNot(beNil())
        expect(request?.url?.absoluteString.contains("key")).to(beTrue())
        expect(request?.url?.absoluteString.contains("queryValue")).to(beTrue())
    }

    private func givenAPostRequestWithBody() {
        testHTTPRequest = DefaultHTTPRequest(method: .post,
                                             apiDefinition: ApiDefinition(endpoint: .home))
        testHTTPRequest.addBody(encodableBody: testBody)
    }

    private func givenAGetRequestWithQueryParams() {
        testHTTPRequest = DefaultHTTPRequest(method: .get,
                                             apiDefinition: ApiDefinition(endpoint: .home),
                                             urlParameters: ["key": "queryValue"])
    }
}

struct TestBody: Encodable {
    let bodyParam: String
}
