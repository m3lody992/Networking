//
//  HTTPBodyEncoder.swift
//  
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// Custom body serialization.
public struct HTTPBodyURLQueryEncoder: HTTPParameterEncoder {

	public static func encode(request: URLRequest, with parameters: HTTPParameters?) throws -> URLRequest {
		// It would not make any sense to encode a request without a URL.
		guard request.url != nil
		else {
			throw NetworkingError.missingBaseURL
		}

		guard let parameters = parameters
		else {
			return request
		}

        // Encode Components
        var components = URLComponents()

        // TODO: Currently only supports Int and String; add if need more types
        var urlQueryItems = [URLQueryItem]()
        for (key, value) in parameters {
            if let intValue = value as? Int {
                let stringValue = String(intValue)
                urlQueryItems.append(URLQueryItem(name: key, value: stringValue))
            } else if let stringValue = value as? String {
                urlQueryItems.append(URLQueryItem(name: key, value: stringValue))
            }
        }
        components.queryItems = urlQueryItems

		// Shadow the request argument as a variable so we can change it
		var mutableRequest = request
        mutableRequest.httpBody = components.query?.data(using: .utf8)

		return mutableRequest
	}

}
