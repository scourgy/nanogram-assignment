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
    
}
