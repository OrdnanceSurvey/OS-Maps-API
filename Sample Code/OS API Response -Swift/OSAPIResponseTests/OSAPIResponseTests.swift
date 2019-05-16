//
//  OSAPIResponseTests.swift
//  OSAPIResponseTests
//
//  Created by Dave Hardiman on 15/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
import OSJSON
import Fetch
@testable import OSAPIResponse

class TestValue: NSObject, Decodable {
    let test: String
    init(test: String) {
        self.test = test
        super.init()
    }
    convenience required init?(json: JSON) {
        guard let test = json.stringValueForKey("test") else {
            return nil
        }
        self.init(test: test)
    }
}
final class TestResponse: Response, OSAPIResponse.Parsable, Fetch.Parsable {
    typealias Payload = TestValue
    let results: [TestValue]
    required init(results: [TestValue], header: Header) {
        self.results = results
        super.init(header: header)
    }
}

class OSAPIResponseTests: XCTestCase {

    func testAResponseCanBeParsed() {
        let validJson = "{\"header\":{\"uri\":\"https://os.uk/test\",\"format\":\"json\"},\"results\":[{\"test\":\"value\"}]}".dataUsingEncoding(NSUTF8StringEncoding)!
        let json = JSON(data: validJson)!
        let response = TestResponse.create(json)
        expect(response?.header.uri).to(equal("https://os.uk/test"))
        expect(response?.header.format).to(equal("json"))
        expect(response?.results).to(haveCount(1))
        expect(response?.results.first?.test).to(equal("value"))
    }

    func testInvalidHeaderFailsToParse() {
        let invalidJson = "{\"header\":{\"uri\":\"https://os.uk/test\"},\"results\":[{\"test\":\"value\"}]}".dataUsingEncoding(NSUTF8StringEncoding)!
        let json = JSON(data: invalidJson)!
        let response = TestResponse.create(json)
        expect(response).to(beNil())
    }

    func testInvalidPayloadIsNotParsedButIgnored() {
        let invalidJson = "{\"header\":{\"uri\":\"https://os.uk/test\",\"format\":\"json\"},\"results\":[{}]}".dataUsingEncoding(NSUTF8StringEncoding)!
        let json = JSON(data: invalidJson)!
        let response = TestResponse.create(json)
        expect(response?.results).to(haveCount(0))
    }

    func testAValidResponseCanBeParsedInFetch() {
        let validJson = "{\"header\":{\"uri\":\"https://os.uk/test\",\"format\":\"json\"},\"results\":[{\"test\":\"value\"}]}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: validJson, withStatus: 200)
        switch response {
        case .Success(let test):
            expect(test.header.uri).to(equal("https://os.uk/test"))
            expect(test.header.format).to(equal("json"))
            expect(test.results).to(haveCount(1))
            expect(test.results.first?.test).to(equal("value"))
        default:
            fail("Unexpected response")
        }
    }

    func testInvalidHeaderReturnsDeserialisationError() {
        let invalidJson = "{\"header\":{\"uri\":\"https://os.uk/test\"},\"results\":[{\"test\":\"value\"}]}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: invalidJson, withStatus: 200)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .FailedToDeserialiseJSON:
                expect(error.toNSError().localizedDescription).to(equal("Failed to deserialise JSON message"))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorFailedToDeserialiseJSON))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }

    }

    func testAnErrorResponseCanBeParsed() {
        let errorResponse = "{\"error\":{\"statuscode\":400,\"message\":\"UPRN is invalid.\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 400)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .BadRequest(let message):
                expect(message).to(equal("UPRN is invalid."))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorBadRequest))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testNoDataReturnsAnError() {
        let response = TestResponse.parse(fromData: nil, withStatus: 400)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .NoDataReceived:
                expect(error.toNSError().localizedDescription).to(equal("No data received"))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorNoDataReceived))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testInvalidJSONResponseCanBeParsedToAnError() {
        let errorResponse = "{]".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 400)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .FailedToParseJSON:
                expect(error.toNSError().localizedDescription).to(equal("Failed to parse JSON, it may be badly formed"))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorFailedToParseJSON))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testAnUnauthorisedResponseCanBeParsed() {
        let errorResponse = "{\"fault\":{\"faultstring\":\"InvalidApiKey\",\"detail\":{\"errorcode\":\"oauth.v2.InvalidApiKey\"}}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 401)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .Unauthorised(let message):
                expect(message).to(equal("InvalidApiKey"))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorUnauthorised))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testANotFoundResponseCanBeParsed() {
        let errorResponse = "{\"ErrorResponse\":{\"error\":{\"statuscode\":\"404\",\"message\":\"Resourcenotfound\"}}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 404)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .NotFound(let message):
                expect(message).to(equal("Resourcenotfound"))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorNotFound))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testAMethodNotAllowedResponseCanBeParsed() {
        let errorResponse = "{\"fault\":{\"faultstring\":\"Method not allowed\",\"detail\":{\"errorcode\":\"\"}}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 405)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .MethodNotAllowed(let message):
                expect(message).to(equal("Method not allowed"))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorMethodNotAllowed))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testANotAcceptableResponseCanBeParsed() {
        let errorResponse = "{\"error\":{\"statuscode\":406,\"message\":\"format is not valid.\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 406)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .NotAcceptable(let message):
                expect(message).to(equal("format is not valid."))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorNotAcceptable))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

    func testAServerErrorResponseCanBeParsed() {
        let errorResponse = "{\"error\":{\"statuscode\":500,\"message\":\"Server error.\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let response = TestResponse.parse(fromData: errorResponse, withStatus: 500)
        switch response {
        case .Failure(let error as ResponseError):
            switch error {
            case .ServerError(let message):
                expect(message).to(equal("Server error."))
                expect(error.toNSError().localizedDescription).to(equal(message))
                expect(error.toNSError().domain).to(equal(OSAPIResponseErrorDomain))
                expect(error.toNSError().code).to(equal(OSAPIResponseErrorServerError))
            default:
                fail("Unexpected response")
            }
        default:
            fail("Unexpected response")
        }
    }

}
