//
//  HTTPCodableEncoder.swift
// 
//
//  Created by Eric Cartmenez on 17/06/2020.
//  Copyright © 2020 Eric Cartmenez All rights reserved.
//

import Foundation

public struct HTTPCodableEncoder {

    public static func encode<T: Codable> (request: URLRequest, with object: T?) throws -> URLRequest {
        // It would not make any sense to encode a request without a URL.
        guard request.url != nil
        else {
            throw NetworkingError.missingBaseURL
        }

        guard let object = object
        else {
            return request
        }

        guard let data = try? JSONEncoder().encode(object)
        else {
            return request
        }

        // Shadow the request argument as a variable so we can change it
        var request = request
        request.httpBody = data

        return request
    }

}
