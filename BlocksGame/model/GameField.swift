//
//  GameField.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 07/02/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class GameField {
    
    private var filledCells = [[Bool]]()
    
    private let rows: Int
    private let cols: Int
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        for i in 0 ..< rows {
            filledCells.append([])
            for _ in 0 ..< cols {
                filledCells[i].append(false)
            }
        }
    }
    
    func addFigure(figure: Figure, cellPosition: CellPosition?) -> Step {
        guard let cellPosition = cellPosition else {
            return Step(added: [], removed: [])
        }
        if !isFigureFit(figure: figure, cellPosition: cellPosition) {
            return Step(added: [], removed: [])
        }
        
        var addedCellPositions: [CellPosition] = []
        for point in figure.points {
            addedCellPositions.append(CellPosition(x: cellPosition.x + point.x, y: cellPosition.y + point.y))
            filledCells[cellPosition.x + point.x][cellPosition.y + point.y] = true
        }
        
        var removedCellPositions: [CellPosition] = []
        if addedCellPositions.count > 0 {
            removedCellPositions = getCellPositionsToRemove()
            for position in removedCellPositions {
                filledCells[position.x][position.y] = false
            }
        }
        
        return Step(added: addedCellPositions, removed: removedCellPositions)
    }
    
    func isCellFilled(cellPosition: CellPosition) -> Bool {
        return filledCells[cellPosition.x][cellPosition.y]
    }
    
    func isFigureFit(figure: Figure) -> Bool {
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                if isFigureFit(figure: figure, cellPosition: CellPosition(x: i, y: j)) {
                    return true
                }
            }
        }
        return false
    }
    
    func isFigureFit(figure: Figure, cellPosition: CellPosition) -> Bool {
        var isFit = true
        for point in figure.points {
            let x = cellPosition.x + point.x
            let y = cellPosition.y + point.y
            if x < 0 || x >= rows || y < 0 || y >= cols || filledCells[x][y] {
                isFit = false
            }
        }
        return isFit
    }
    
    func getFilledCellPositions() -> [CellPosition] {
        var filledCellPositions: [CellPosition] = []
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                if filledCells[i][j] {
                    filledCellPositions.append(CellPosition(x: i, y: j))
                }
            }
        }
        return filledCellPositions
    }
    
    func setFilledCellPositions(filledCellPositions: [CellPosition]) {
        for cellPosition in filledCellPositions {
            filledCells[cellPosition.x][cellPosition.y] = true
        }
    }
    
    private func getCellPositionsToRemove() -> [CellPosition] {
        var positionsToRemove = Set<CellPosition>()
        
        for i in 0 ..< rows {
            if filledCells.filter({$0[i] != false}).count == cols {
                for j in 0 ..< cols {
                    positionsToRemove.insert(CellPosition(x: j, y: i))
                }
            }
            if !filledCells[i].contains(false) {
                for j in 0 ..< cols {
                    positionsToRemove.insert(CellPosition(x: i, y: j))
                }
            }
        }
        
        for i in 0 ..< rows / 3 {
            for j in 0 ..< cols / 3 {
                let x = i * 3
                let y = j * 3
                let cellPositionsToCheck = [CellPosition(x: x, y: y), CellPosition(x: x + 1, y: y), CellPosition(x: x + 2, y: y),
                                            CellPosition(x: x, y: y + 1), CellPosition(x: x + 1, y: y + 1),
                                            CellPosition(x: x + 2, y: y + 1), CellPosition(x: x, y: y + 2),
                                            CellPosition(x: x + 1, y: y + 2), CellPosition(x: x + 2, y: y + 2)]
                if !cellPositionsToCheck.contains(where: { !isCellFilled(cellPosition: $0) }) {
                    positionsToRemove = positionsToRemove.union(cellPositionsToCheck)
                }
            }
        }
        
        return Array(positionsToRemove)
    }
    
}
