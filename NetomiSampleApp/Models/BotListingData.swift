//
//  BotListingData.swift
//
//  Created by Akash Gupta on 20/12/24
//  Copyright (c) . All rights reserved.
//

import Foundation

struct BotListingData: Codable {

  enum CodingKeys: String, CodingKey {
    case bots
  }

  var bots: [Bots]?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    bots = try container.decodeIfPresent([Bots].self, forKey: .bots)
  }

}
