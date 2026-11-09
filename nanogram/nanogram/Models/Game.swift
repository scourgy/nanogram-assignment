//
//  Game.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

struct Game: Codable {
    
    let id: String
    let title: String
    let html: String
    let creator: GameCreator?
    let stats: GameStats
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        guard !id.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Game id must not be empty.")
        }
    
        html = try container.decode(String.self, forKey: .html)
        guard !html.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .html, in: container, debugDescription: "Game html must not be empty.")
        }
        
        title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? "Unknown title"
        creator = try? container.decodeIfPresent(GameCreator.self, forKey: .creator)
        stats = (try? container.decodeIfPresent(GameStats.self, forKey: .stats)) ?? GameStats(plays: 0, likes: 0)
    }
    
}
