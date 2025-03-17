//
//  JWTTokenData.swift
//
//  Created by Akash Gupta on 06/01/25
//  Copyright (c) . All rights reserved.
//

import Foundation

struct JWTTokenData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case message
        case token
        case statusCode
    }
    
    var message: String?
    var token: String?
    var statusCode: Int?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
    }
    
}
