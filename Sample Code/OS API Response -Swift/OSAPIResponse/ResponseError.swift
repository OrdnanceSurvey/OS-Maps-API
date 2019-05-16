//
//  ResponseError.swift
//  OSAPIResponse
//
//  Created by Dave Hardiman on 15/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/**
 Potential errors returned when executing a request to an OS API

 - NoDataReceived:          No data received from the server.
 - BadRequest:              Request was not properly formed, see localised desctription for detail.
 - Unauthorised:            Unauthorised request for this API key.
 - NotFound:                The resource requested can't be found
 - MethodNotAllowed:        Method not allowed. See localised description for detail
 - NotAcceptable            The request wasn't acceptable. See localised description for detail
 - ServerError:             The server has returned an error. See localised desctription for detail.
 - FailedToParseJSON:       JSON parsing has failed, likely due to invalid JSON.
 - FailedToDeserialiseJSON: JSON was valid, but cannot be deserialised.
 - UnknownError:            An error has occured which is none of the above.
 */
public enum ResponseError: ErrorType {
    case NoDataReceived
    case BadRequest(String)
    case Unauthorised(String)
    case NotFound(String)
    case MethodNotAllowed(String)
    case NotAcceptable(String)
    case ServerError(String)
    case FailedToParseJSON
    case FailedToDeserialiseJSON
    case UnknownError

    func rawValue() -> Int {
        switch self {
        case .NoDataReceived:
            return OSAPIResponseErrorNoDataReceived
        case .BadRequest:
            return OSAPIResponseErrorBadRequest
        case .Unauthorised:
            return OSAPIResponseErrorUnauthorised
        case .NotFound:
            return OSAPIResponseErrorNotFound
        case .MethodNotAllowed:
            return OSAPIResponseErrorMethodNotAllowed
        case .NotAcceptable:
            return OSAPIResponseErrorNotAcceptable
        case .ServerError:
            return OSAPIResponseErrorServerError
        case .FailedToDeserialiseJSON:
            return OSAPIResponseErrorFailedToDeserialiseJSON
        case .FailedToParseJSON:
            return OSAPIResponseErrorFailedToParseJSON
        case .UnknownError:
            return OSAPIResponseErrorUnknownError
        }
    }

    func errorDescription() -> String {
        switch self {
        case .NoDataReceived:
            return "No data received"
        case .BadRequest(let message):
            return message
        case .Unauthorised(let message):
            return message
        case .NotFound(let message):
            return message
        case .MethodNotAllowed(let message):
            return message
        case .NotAcceptable(let message):
            return message
        case .ServerError(let message):
            return message
        case .FailedToDeserialiseJSON:
            return "Failed to deserialise JSON message"
        case .FailedToParseJSON:
            return "Failed to parse JSON, it may be badly formed"
        case .UnknownError:
            return "Unknown error occurred"
        }
    }

    /**
     Converts this error in to a usable NSError for Objective-C to use
     */
    public func toNSError() -> NSError {
        return NSError(domain: OSAPIResponseErrorDomain, code: self.rawValue(), userInfo: [NSLocalizedDescriptionKey: errorDescription()])
    }
}
