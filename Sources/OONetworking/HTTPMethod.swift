//
//  HTTPMethod.swift
//
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// An enum encompassing standard HTTP methods.
public enum HTTPMethod: String {

	case get = "GET"
	case post = "POST"
	case delete = "DELETE"
	case patch = "PATCH"
	case put = "PUT"
	case connect = "CONNECT"
	case head = "HEAD"
	case options = "OPTIONS"
	case trace = "TRACE"

}
