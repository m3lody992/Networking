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
    public let requireLogin: Bool?
    public let message: String?
    public let spam: Bool?
    public let feedbackTitle: String?
    public let code: Int?
    
    public init(status: String, requireLogin: Bool?, message: String?, spam: Bool?, feedbackTitle: String?, code: Int? = nil) {
        self.status = status
        self.requireLogin = requireLogin
        self.message = message
        self.spam = spam
        self.feedbackTitle = feedbackTitle
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case status
        case requireLogin = "require_login"
        case message
        case spam
        case feedbackTitle = "feedback_title"
        case code
    }

}
