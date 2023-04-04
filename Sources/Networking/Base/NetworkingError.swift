//
//  NetworkingError.swift
//
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// Networking errors.
public enum NetworkingError: Error {

	case emptyResponse
	case deserializationFailed(underlyingError: Error)
	case invalidResponse
	case missingBaseURL
	case corruptData
	case authenticationError
	case badRequest
	case unknown(Error?)
	case realtimeRequest(code: Int, message: String)
    case errorObject(APIError, rawData: Data, statusCode: Int)
    case sessionError(rawData: Data, statusCode: Int)

    public var debugDescription: String {
        switch self {
        case .emptyResponse: return "empty_response" // "empty_response"
        case .deserializationFailed: return "deserialization_failed" // "deserialization_failed"
        case .invalidResponse: return "invalid_response" // "invalid_response"
        case .missingBaseURL: return "missing_base_url" // "missing_base_url"
        case .corruptData: return "corrupt_data" // "corrupt_data"
        case .authenticationError: return "authentication_error" // "authentication_error"
        case .badRequest: return "bad_request" // "bad_request"
        case .unknown: return "unknown" // "unknown"
        case .realtimeRequest: return "realtime_request_error" // "realtime_request_error"
        case .errorObject(let error, _, let statusCode): return "error_" + "\(statusCode)_\(error.status)_\(error.message ?? "unknown")"
        case .sessionError(_, let statusCode): return "session_error_\(statusCode)"
        }
    }

}
