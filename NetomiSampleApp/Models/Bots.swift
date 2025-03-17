//
//  Bots.swift
//
//  Created by Akash Gupta on 20/12/24
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Bots: Codable {
    
    enum Environment: String, Codable {
        case us = "us"
        case eu = "eu"
        case sg = "sg"
        case qa = "qa"
        case qaint = "qaint"
        case dev = "dev"
    }
    
    enum CodingKeys: String, CodingKey {
        case logo
        case env
        case username
        case botName
        case botId
        case botRefId
        case entryId
        case version
    }
    
    var logo: String?
    var env: Environment?
    var username: String?
    var botName: String?
    var botId: String?
    var botRefId: String?
    var entryId: Int?
    var version: String?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        env = try? container.decodeIfPresent(Environment.self, forKey: .env)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        botName = try container.decodeIfPresent(String.self, forKey: .botName)
        botId = try container.decodeIfPresent(String.self, forKey: .botId)
        botRefId = try container.decodeIfPresent(String.self, forKey: .botRefId)
        entryId = try container.decodeIfPresent(Int.self, forKey: .entryId)
        version = try container.decodeIfPresent(String.self, forKey: .version)
    }
    
}
