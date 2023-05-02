//
//  MockURLProtocol.swift
//  
//
//  Created by Ruben Dario Garcia Astudillo on 27/04/23.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var response: HTTPURLResponse?
    static var stubResponseData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let response = MockURLProtocol.response {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = MockURLProtocol.stubResponseData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
