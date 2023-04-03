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
    public let spam: Bool?
    public let feedbackTitle: String?
    
    public init(status: String, message: String?, spam: Bool?, feedbackTitle: String?) {
        self.status = status
        self.message = message
        self.spam = spam
        self.feedbackTitle = feedbackTitle
    }

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case spam
        case feedbackTitle = "feedback_title"
    }

}
