//
//  NetworkingClient.swift
//  
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// A protocol defining a common networking client.
public protocol NetworkingClient {

	associatedtype Engine

	var engine: Engine { get }
	var authenticator: NetworkingAuthenticator? { get }
	var decoder: JSONDecoder { get }

}
