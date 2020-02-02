//
//  ScoreCalculator.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 12/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class ScoreCalculator {
    
    private static let SCORE_FOR_ADDED_CELL = 1
    private static let SCORE_FOR_REMOVED_CELL = 10
    
    func calcScore(currentScore: Int, addedCells: Int, removedCells: Int) -> Int {
        return currentScore + addedCells * ScoreCalculator.SCORE_FOR_ADDED_CELL + removedCells * ScoreCalculator.SCORE_FOR_REMOVED_CELL
    }
    
}
