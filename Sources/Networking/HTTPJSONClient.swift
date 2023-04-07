//
//  HTTPJSONClient.swift
// 
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation
import UIKit

public struct HTTPJSONClient<Endpoint: HTTPEndpoint>: HTTPNetworkingClient {

	// The underlying networking client, doing all the hard work.
	public private(set) var engine: URLSession

	// Authentication mechanism.
	public private(set) var authenticator: NetworkingAuthenticator?

	// Custom JSON decoder.
	public let decoder: JSONDecoder

	// Convenience initializer with a default URL session and configuration.
	public init(authenticator: NetworkingAuthenticator? = nil, decoder: JSONDecoder = JSONDecoder()) {
		// Create a custom session configuration.
		let configuration = URLSessionConfiguration.default
		configuration.allowsCellularAccess = true

		// Creates a custom session.
		let session = URLSession(configuration: configuration)

		self.init(engine: session, authenticator: authenticator, decoder: decoder)
	}

	// Default initializer which accepts a custom URL session.
	public init(engine: URLSession, authenticator: NetworkingAuthenticator? = nil, decoder: JSONDecoder = JSONDecoder()) {
		self.engine = engine
		self.authenticator = authenticator
		self.decoder = decoder
	}

	// MARK: - Data tasks

	// Start a JSON request and call a completion block when done.
	@discardableResult
    public func json<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
		process(endpoint: endpoint, using: decodeJSON, completion: completion)
	}

    // Start a Data request and call a completion block when done.
    @discardableResult
    public func data(_ endpoint: Endpoint, completion: @escaping (Result<Data, NetworkingError>) -> Void) -> URLSessionDataTask? {
        process(endpoint: endpoint, using: forwardData, completion: completion)
    }

	// Start an image request and call a completion block when done.
	@discardableResult
	public func image<T: UIImage>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
		process(endpoint: endpoint, using: decodeImage, completion: completion)
	}

	// Start a request from the specified endpoint, decode the response and execute a completion block when done.
	private func process<T>(endpoint: Endpoint, using decode: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
		do {
			// Prepare the URL request.
			let request = try prepare(endpoint: endpoint)

			// Return the request.
			return send(request: request) { result in
				switch result {
				case let .failure(error):
					completion(.failure(error))
				case let .success(data):
					self.decode(data: data, using: decode, completion: completion)
				}
			}
		}
		catch {
			// In case of any other failure, pass the error in the result type.
			completion(.failure(.unknown(error)))

			return nil
		}
	}

	// MARK: - Data task response handling

	// Start a URL request and pass the returned data to the completion block.
	private func send(request: URLRequest, completion: @escaping (Result<Data?, NetworkingError>) -> Void) -> URLSessionDataTask? {
		// Since there is no cached response for the request, we should create a data task and execute it.
		let task = engine.dataTask(with: request) { (data, response, error) in
			// In case of any error we make sure we pass a Result of type failure.
			if let error = error {
				completion(.failure(.unknown(error)))
				return
			}

			guard let data = data
			else {
				completion(.failure(.emptyResponse))
				return
			}

			guard let response = response as? HTTPURLResponse
			else {
				completion(.failure(.emptyResponse))
				return
			}

            // Attempt to parse the response data as API error in case it is not in 200...299 range, but only if it is from instagram!
            if let urlString = request.url?.absoluteString,
               Networking.feedbackPaths.contains(where: urlString.contains) {
                if let parsedError: APIError = try? self.decodeJSON(data: data),
                   parsedError.status != "ok" { // "ok"
                    completion(.failure(.errorObject(parsedError, rawData: data, statusCode: response.statusCode)))
                    return
                }
            } else if let urlString = response.url?.absoluteString,
                      urlString == "https://www.instagram.com/" || (300...399).contains(response.statusCode) {
                completion(.failure(.errorObject(.init(
                    status: "session_error",
                    requireLogin: true,
                    message: nil,
                    spam: nil,
                    feedbackTitle: nil), rawData: data, statusCode: response.statusCode)))
                return
            }

			switch response.statusCode {
			case 200...299:
				completion(.success(data))
			case 401...500:
				completion(.failure(.authenticationError))
			case 501...599, 400:
				completion(.failure(.badRequest))
			default:
				completion(.failure(.unknown(nil)))
			}
		}

		task.resume()

		return task
	}

	// MARK: - Request

	// Do any last minute preparations for the endpoint and encode it into a request.
	private func prepare(endpoint: Endpoint) throws -> URLRequest {

		// Encode the endpoint request.
		var request = try endpoint.encode()
        request.timeoutInterval = 60

		// Authenticate the request, if the endpoint needs it and if there's an authenticator configured.
		if let authenticator = authenticator,
		   let authenticatedEndpoint = endpoint as? Authenticatable,
		   authenticatedEndpoint.needsAuthentication {
			request = try authenticator.authenticate(endpoint: endpoint, timestamp: nil)
		}

		return request
	}

	// MARK: - Data decoding

	// Decode the returned data and apply the passed decoding method.
	private func decode<T>(data: Data?, using decode: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkingError>) -> Void) {
		// Unwrap the data, or call the completion with an empty response error.
		guard let data = data
		else {
			completion(.failure(.emptyResponse))
			return
		}

		// Try to decode the data and call the completion with the decoded object.
		do {
			completion(.success(try decode(data)))
		}
		catch {
			// If the decoding fails, call the completion with a deserialization error.
			completion(.failure(.deserializationFailed(underlyingError: error)))
		}
	}

	// Decode the returned JSON data and try to create an object out of it.
	private func decodeJSON<T: Decodable>(data: Data) throws -> T {
		do {
			// Try deserializing the returned JSON into the destination generic type.
			return try decoder.decode(T.self, from: data)
		}
		catch {
			// Return a general deserialization error.
			throw NetworkingError.deserializationFailed(underlyingError: error)
		}
	}

    // Forward Data here due to protocol requiring a function
    private func forwardData(data: Data) throws -> Data {
        data
    }

	// Decode the returned data as an image.
	private func decodeImage<T: UIImage>(data: Data) throws -> T {
		guard let image = T(data: data)
		else {
			throw NetworkingError.invalidResponse
		}

		return image
	}

}
