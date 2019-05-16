//
//  Response.swift
//  OSAPIResponse
//
//  Created by Dave Hardiman on 14/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import OSJSON

/**
 *  Base class to use for API responses. Used in conjunction with
 *  `Parsable` this can provide a common generic base from which
 *  the common header/results basic API structure can be built.
 */
@objc(OSResponse)
public class Response: NSObject {
    /// The header from the response
    public let header: Header

    /**
     Initialiser

     - parameter header: The header from the response
     */
    public init(header: Header) {
        self.header = header
        super.init()
    }
}

/**
 *  This provides the generic part of the base structure
 */
public protocol Parsable {
    /// The type to use for the results payload
    associatedtype Payload: Decodable

    /// A readonly property for the results
    var results: [Payload] { get }

    /**
     Initialiser. When an object inherits from Response and Parsable,
     it should implement this and then call super(header: header)

     - parameter results: The results set from the response
     - parameter header:  The header from the response
     */
    init(results: [Payload], header: Header)
}

// MARK: Declaration for string constants to be used to decode and also serialize.
private let ResultsKey: String = "results"
private let HeaderKey: String = "header"

public extension Parsable {
    /**
     Attempts to create a new instance of this object from the JSON passed in

     - parameter json: The JSON from which to construct this object

     - returns: A valid object or nil if the header or results array couldn't be created
     */
    public static func create(json: JSON) -> Self? {
        guard let results = json.jsonArrayForKey(ResultsKey)?.flatMap({ Payload.init(json: $0) }),
            headerJSON = json.jsonForKey(HeaderKey),
            header = Header(json: headerJSON)
            else {
                return nil
        }
        return self.init(results: results, header: header)
    }
}
