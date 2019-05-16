//
//  Header.swift
//  OSAPIResponse
//
//  Created by Dave Hardiman on 14/03/2016
//  Copyright (c) Ordnance Survey. All rights reserved.
//

import Foundation
import OSJSON

@objc(OSHeader)
public class Header: NSObject, Decodable {

    // MARK: Properties
    public let uri: String
    public let format: String


    init(uri: String, format: String) {
        self.uri = uri
        self.format = format
        super.init()
    }

    //MARK: JSON initialiser
    convenience required public init?(json: JSON) {
        guard let uri = json.stringValueForKey(Header.UriKey),
            format = json.stringValueForKey(Header.FormatKey)
            else {
                return nil
        }
        self.init(
            uri: uri,
            format: format
        )
    }
}

extension Header {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    @nonobjc internal static let UriKey: String = "uri"
    @nonobjc internal static let FormatKey: String = "format"
    
}
