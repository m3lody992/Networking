//
//  NetworkResponse.swift
// 
//
//  Created by Eric Cartmenez on 08/07/2020.
//  Copyright © 2020 Eric Cartmenez All rights reserved.
//

import Foundation

public struct NetworkResponse: Codable {

    public var status: String
    public var maxOrderSize: Int?
    public var maxAvailableToAdd: Int?
    public var message: String?
    public var title: String?
    public var description: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case maxOrderSize = "max_order_size"
        case maxAvailableToAdd = "max_available_to_add"
        case title
        case description
    }

}
