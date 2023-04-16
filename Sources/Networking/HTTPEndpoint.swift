//
//  HTTPEndpoint.swift
//
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [(String, Any)]
public typealias HTTPParameters = [(String, Any)]

// A protocol describing an HTTP endpoint.
public protocol HTTPEndpoint {

	var baseURL: URL { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var queryParameters: HTTPParameters? { get }
	var headers: HTTPHeaders? { get }
	var bodyQueryParameters: HTTPParameters? { get }
	var contentType: HTTPContentType { get }
    var rawFormData: Data? { get set }
    var cookies: [HTTPCookie]? { get }

	func encode() throws -> URLRequest
    mutating func encodeModelToData<T: Codable>(_ model: T)

}

public extension HTTPEndpoint {

    mutating func encodeModelToData<T: Codable>(_ model: T) {
        guard let data = try? JSONEncoder().encode(model) else { return }
        rawFormData = data
    }

	// Encode the current endpoint as a request
	func encode() throws -> URLRequest {
		var request = URLRequest(url: baseURL.appendingPathComponent(path))
		request.httpMethod = method.rawValue

		// Encode any query string parameters
		request = try HTTPQueryStringEncoder.encode(request: request, with: queryParameters)
		// Encode the custom headers
		request = try HTTPHeaderEncoder.encode(request: request, with: headers)
        // Encode custom url query parameters
        if let bodyQueryParameters = bodyQueryParameters {
            request = try HTTPBodyURLQueryEncoder.encode(request: request, with: bodyQueryParameters)
        } else if let rawFormData = rawFormData {
            request.httpBody = rawFormData
        }

        if contentType == .json {
            request = try HTTPHeaderEncoder.encode(request: request, with: [
                ("Accept", contentType.rawValue),
                ("Content-Type", contentType.rawValue),
                ("User-Agent", Networking.appName + String(Networking.version))
            ])
        }

        if let cookies = cookies {
            HTTPCookieStorage.shared.setCookies(cookies, for: request.url, mainDocumentURL: nil)
        }

        return request
	}

}
