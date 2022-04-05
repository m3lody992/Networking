//
//  Cookie.swift
//
//
//  Created by Eric Cartmenez on 13/08/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

public struct Cookie: Codable, Equatable {

    public var domain: String
    public var path: String
    public var name: String
    public var value: String
    public var isSecure: Bool
    public var expiresDate: Date?

    public init(cookie: HTTPCookie) {
        domain = cookie.domain
        path = cookie.path
        name = cookie.name
        value = cookie.value
        isSecure = cookie.isSecure
        expiresDate = cookie.expiresDate
    }

    public var asHTTPCookie: HTTPCookie? {
        HTTPCookie(properties: [
            .domain: domain,
            .path: path,
            .name: name,
            .value: value,
            .secure: isSecure,
            .expires: expiresDate
        ])
    }
}
