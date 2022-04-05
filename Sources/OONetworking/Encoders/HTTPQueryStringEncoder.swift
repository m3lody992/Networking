//
//  HTTPQueryStringEncoder.swift
// 
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// Custom URL parameter encoder.
public struct HTTPQueryStringEncoder: HTTPParameterEncoder {

	public static func encode(request: URLRequest, with parameters: HTTPParameters?) throws -> URLRequest {
		// It would not make any sense to encode a request without a URL.
		guard let url = request.url
		else {
			throw NetworkingError.missingBaseURL
		}

		// Make sure we can create components out of the URL and that we don't do anything if the parameter list is empty.
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
		      let parameters = parameters
		else {
			return request
		}

		// Shadow the request argument as a variable so we can change it
		var request = request

		// Map the parameter dictionary to query items.
		let queryItems = parameters.map { key, value -> URLQueryItem in
			return URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
		}

		components.queryItems = queryItems
		request.url = components.url

		return request
	}

}
