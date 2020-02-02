//
//  Figure.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 07/12/2019.
//  Copyright © 2019 Svetlana Gladysheva. All rights reserved.
//

import Foundation


struct Figure: Codable {
    
    var points: [CellPosition]
    
    init(points: [CellPosition]) {
        self.points = points
    }
    
    static var allPossible: [Figure] {
        return [
            Figure(points: [CellPosition(x: 0, y: 0)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 0, y: 1)]),
            Figure(points: [CellPosition(x: -1, y: 0), CellPosition(x: 0, y: 0), CellPosition(x: 0, y: -1), CellPosition(x: 1, y: -1)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 0, y: 1), CellPosition(x: -1, y: 0), CellPosition(x: 1, y: 0)]),
            Figure(points: [CellPosition(x: -1, y: 0), CellPosition(x: 0, y: 1), CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 1)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 0, y: 1), CellPosition(x: 0, y: 2), CellPosition(x: 1, y: 0)]),
            Figure(points: [CellPosition(x: -1, y: 0), CellPosition(x: 0, y: 2), CellPosition(x: 0, y: 1), CellPosition(x: 0, y: 0)]),
            Figure(points: [CellPosition(x: 0, y: 1), CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 1), CellPosition(x: 1, y: 0)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0), CellPosition(x: 2, y: 0), CellPosition(x: -1, y: 0)]),
            Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0), CellPosition(x: -1, y: 0), CellPosition(x: 0, y: -1), CellPosition(x: 0, y: 1)])
        ]
    }
    
}
