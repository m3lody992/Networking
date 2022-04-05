//
//  Response.swift
// 
//
//  Created by Eric Cartmenez on 07/10/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

public struct APIError: Error, Codable {

    public let status: String
    public let message: String?
    public let feedbackTitle: String?
    
    public init(status: String, message: String?, feedbackTitle: String?) {
        self.status = status
        self.message = message
        self.feedbackTitle = feedbackTitle
    }

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case feedbackTitle = "feedback_title"
    }

}
