//
//  OSResponseErrors.h
//  OSAPIResponse
//
//  Created by Dave Hardiman on 17/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Error domain associated with OS API responses
 */
extern NSString *const OSAPIResponseErrorDomain;

NS_ENUM(NSInteger){
    /**
     *  The server returned no data.
     */
    OSAPIResponseErrorNoDataReceived,
    /**
     *  Request was not properly formed, see localised desctription for detail.
     */
    OSAPIResponseErrorBadRequest,
    /**
     *  Unauthorised request for this API key.
     */
    OSAPIResponseErrorUnauthorised,
    /**
     *  Resource requested was not found
     */
    OSAPIResponseErrorNotFound,
    /**
     *  Requested method is not allowed
     */
    OSAPIResponseErrorMethodNotAllowed,
    /**
     *  Requested format is not acceptable
     */
    OSAPIResponseErrorNotAcceptable,
    /**
     *  The server has returned an error. See localised desctription for detail.
     */
    OSAPIResponseErrorServerError,
    /**
     *  The JSON was malformed and could not be parsed.
     */
    OSAPIResponseErrorFailedToParseJSON,
    /**
     *  The JSON response could not be deserialised into a response object.
     */
    OSAPIResponseErrorFailedToDeserialiseJSON,
    /**
     *  An error occurred which was none of the above.
     */
    OSAPIResponseErrorUnknownError,
};
