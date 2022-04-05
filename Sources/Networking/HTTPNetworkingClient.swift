//
//  HTTPNetworkingClient.swift
//  TikTokTips
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation
import UIKit

// A protocol defining common HTTP networking requests.
public protocol HTTPNetworkingClient: NetworkingClient {

	associatedtype Endpoint: HTTPEndpoint

	func json<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask?

	func image<T: UIImage>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask?

}
