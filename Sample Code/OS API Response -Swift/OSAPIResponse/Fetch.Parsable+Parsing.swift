//
//  Fetch.Parsable+Parsing.swift
//  OSAPIResponse
//
//  Created by Dave Hardiman on 15/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Fetch
import OSJSON

extension Fetch.Parsable where Self: OSAPIResponse.Parsable {
    public static func parse(fromData data: NSData?, withStatus status: Int) -> Result<Self> {
        guard let data = data else {
            return .Failure(ResponseError.NoDataReceived)
        }
        guard let json = JSON(data: data) else {
            return .Failure(ResponseError.FailedToParseJSON)
        }
        switch status {
        case 200:
            return parseExpectedResponse(json)
        case 400:
            return .Failure(ResponseError.BadRequest(messageFromErrorBody(json)))
        case 401:
            return .Failure(ResponseError.Unauthorised(messageFromErrorBody(json)))
        case 404:
            return .Failure(ResponseError.NotFound(messageFromErrorBody(json)))
        case 405:
            return .Failure(ResponseError.MethodNotAllowed(messageFromErrorBody(json)))
        case 406:
            return .Failure(ResponseError.NotAcceptable(messageFromErrorBody(json)))
        case 500:
            return .Failure(ResponseError.ServerError(messageFromErrorBody(json)))
        default:
            return .Failure(ResponseError.UnknownError)
        }
    }

    private static func parseExpectedResponse(json: JSON) -> Result<Self> {
        guard let response = Self.create(json) else {
            return .Failure(ResponseError.FailedToDeserialiseJSON)
        }
        return .Success(response)
    }
}

private func messageFromErrorBody(json: JSON) -> String {
    if let error = json.jsonForKey("error"),
        message = error.stringValueForKey("message") {
            return message
    }
    if let fault = json.jsonForKey("fault"),
        message = fault.stringValueForKey("faultstring") {
            return message
    }
    if let errorResponse = json.jsonForKey("ErrorResponse") {
        return messageFromErrorBody(errorResponse)
    }
    return ""
}
