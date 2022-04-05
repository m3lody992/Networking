//
//  NetworkingAuthenticator.swift
//  
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// A protocol for custom networking authenticators.
public protocol NetworkingAuthenticator {

	func authenticate<T>(endpoint: T, timestamp: Date?) throws -> URLRequest

}

