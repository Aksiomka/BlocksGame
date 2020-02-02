//
//  GameState.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 17/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


struct GameState: Codable {
    
    var score: Int
    var figures: [Figure?]
    var filledCellPositions: Set<CellPosition>
    
}
