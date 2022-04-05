//
//  HTTPParameterEncoder.swift
// 
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// Protocol used to provide custom encoding of parameters or HTTP headers.
public protocol HTTPParameterEncoder {

	static func encode(request: URLRequest, with parameters: HTTPParameters?) throws -> URLRequest

}
