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
    
}
