//
//  Storage.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 24/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class Storage {
    
    private let GAME_STATE_KEY = "gameState"
    private let MAX_SCORE_KEY = "maxScore"
    
    func saveGameState(state: GameState) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let json = try? encoder.encode(state) {
            UserDefaults.standard.set(json, forKey: GAME_STATE_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadGameState() -> GameState? {
        if let savedData = UserDefaults.standard.object(forKey: GAME_STATE_KEY) as? Data {
            let decoder = JSONDecoder()
            if let gameState = try? decoder.decode(GameState.self, from: savedData) {
                return gameState
            }
        }
        return nil
    }
    
    func deleteSavedGameState() {
        UserDefaults.standard.removeObject(forKey: GAME_STATE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveMaxScore(score: Int) {
        UserDefaults.standard.set(score, forKey: MAX_SCORE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func loadMaxScore() -> Int {
        return UserDefaults.standard.integer(forKey: MAX_SCORE_KEY)
    }
}
