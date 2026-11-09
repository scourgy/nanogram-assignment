//
//  GamePageResponse.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

struct GamePageResponse: Codable {
    
    let page: Int
    let totalPages: Int
    let nextPage: Int?
    let games: [Game]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        nextPage = try? container.decodeIfPresent(Int.self, forKey: .nextPage)
        games = try container.decodeIfPresent(LossyArray<Game>.self, forKey: .games)?.elements ?? []
    }
    
}
