import XCTest
import Networking

final class NetworkingTests: XCTestCase {

    var sut: APIManager!
    var urlSession: URLSession!
    var body: RequestModelTest!
    var encodedBody: Data!
    var headers: [String: String]!
    let urlString = "https://a-url.com"
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)

        sut = APIManager(urlSession: urlSession)

        body = RequestModelTest(firstName: "First", lastName: "Last", email: "test@test.com", password: "123456")
        encodedBody = try? JSONEncoder().encode(body)
        guard encodedBody != nil else {
            XCTFail("Error encoding request body")
            return
        }
        headers = [
            "Content-type": "aplication/json",
            "Accept":"aplication/json"
        ]
    }
    
    override func tearDown() {
        sut = nil
        urlSession = nil
        body = nil
        encodedBody = nil
        headers = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.response = nil
    }
    
    func testAPIManager_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .post, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(let responseModel):
                XCTAssertEqual(responseModel.status, "ok")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIManager_WhenReceivedDifferentJSONResponse_ErrorTookPlace() {
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .post, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIManager_WhenReceivedNoData_ErrorTookPlace() {
        MockURLProtocol.stubResponseData = nil
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .post, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "The given data was not valid JSON."))))
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIManager_WhenReceivedInvalidStatusCode_ErrorTookPlace() {
        for statusCode in 300...500 {
            let jsonString = "{\"status\":\"ok\"}"
            MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
            let response = HTTPURLResponse(url: URL(string: urlString)!,
                                           statusCode: statusCode,
                                           httpVersion: "HTTP/1.1",
                                           headerFields: headers)
            MockURLProtocol.response = response
            let expectation = expectation(description: "Signup Web Service Response Expectation")
            
            sut.request(method: .post, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
                switch result {
                case .success(_):
                    XCTFail("Expected failure, but got success")
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    break
                }
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testAPIManager_WhenBadURLProvided_ErrorTookPlace() {
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .get, urlString: "Bad URL") { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.badURL)
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    func testAPIManager_GetMethod_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .get, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(let responseModel):
                XCTAssertEqual(responseModel.status, "ok")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    func testAPIManager_PutMethod_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .put, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(let responseModel):
                XCTAssertEqual(responseModel.status, "ok")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAPIManager_DeleteMethod_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let response = HTTPURLResponse(url: URL(string: urlString)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: headers)
        MockURLProtocol.response = response
        let expectation = expectation(description: "Signup Web Service Response Expectation")
        
        sut.request(method: .put, urlString: urlString, body: encodedBody, headers: headers) { (result: Result<ResponseModelTest, NetworkingError>)  in
            switch result {
            case .success(let responseModel):
                XCTAssertEqual(responseModel.status, "ok")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    // MARK: - Helpers
    
    struct RequestModelTest: Encodable {
        private let firstName: String
        private let lastName: String
        private let email: String
        private let password: String
        
        init(firstName: String, lastName: String, email: String, password: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.password = password
        }
    }
    
    struct ResponseModelTest: Decodable {
        let status: String

        init(status: String) {
            self.status = status
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}
