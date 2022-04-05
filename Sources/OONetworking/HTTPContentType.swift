//
//  HTTPContentType.swift
//
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// An enum encompassing common content types.
public enum HTTPContentType: String {

	case json = "application/json"
	case data = "application/data"
	case text = "text/plain"
    case urlEncoded = "application/x-www-form-urlencoded"

}
