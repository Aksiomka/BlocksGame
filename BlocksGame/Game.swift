//
//  Game.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 19/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class Game {
    
    var gameScene: GameSceneProtocol!
    private let storage = Storage()
    private let scoreCalculator = ScoreCalculator()
    private var figures: [Figure?] = []
    private var cellStates = [[Bool]]()
    private var score = 0
    
    init() {
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            cellStates.append([])
            for _ in 0 ..< Constants.NUMBER_OF_CELLS {
                cellStates[i].append(false)
            }
        }
    }
    
    func onLoad() {
        loadGameState()
        loadMaxScore()
    }
    
    func onFigureDragBegan(position: Int) {
        gameScene.increaseFigure(position: position)
    }
    
    func onFigureMoved(cellPositions: [CellPosition?]) {
        let filteredCellPositions = filterCellPositions(positions: cellPositions)
        gameScene.highlightCells(cellPositions: filteredCellPositions)
    }
    
    func onFigureDropped(cellPositions: [CellPosition?], figureNumber: Int) {
        let filteredCellPositions = filterCellPositions(positions: cellPositions)
        for position in filteredCellPositions {
            cellStates[position.x][position.y] = true
        }
        gameScene.addFilledCells(cellPositions: filteredCellPositions)
        
        if filteredCellPositions.count > 0 {
            gameScene.removeFigure(position: figureNumber)
            
            figures[figureNumber] = nil
            if !figures.contains(where: {$0 != nil}) {
                addFigures()
            }
            for cellPosition in filteredCellPositions {
                cellStates[cellPosition.x][cellPosition.y] = true
            }
            
            let cellPositionsToClear = getCellPositionsToClear()
            clearCells(positionsToClear: cellPositionsToClear)
            
            updateScore(addedCells: filteredCellPositions.count, removedCells: cellPositionsToClear.count)
            
            saveGameState()
            checkFiguresDisabled()
            
        } else {
            gameScene.moveFigureToInitialPosition(position: figureNumber)
            gameScene.decreaseFigure(position: figureNumber)
        }
        
        gameScene.highlightCells(cellPositions: [])
    }
    
    private func getCellPositionsToClear() -> [CellPosition] {
        var positionsToClear = [CellPosition]()
        
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            if cellStates.filter({$0[i] != false}).count == Constants.NUMBER_OF_CELLS {
                for j in 0 ..< Constants.NUMBER_OF_CELLS {
                    positionsToClear.append(CellPosition(x: j, y: i))
                }
            }
            if !cellStates[i].contains(false) {
                for j in 0 ..< Constants.NUMBER_OF_CELLS {
                    positionsToClear.append(CellPosition(x: i, y: j))
                }
            }
        }
        
        for i in 0 ..< Constants.NUMBER_OF_CELLS / 3 {
            for j in 0 ..< Constants.NUMBER_OF_CELLS / 3 {
                let x = i * 3
                let y = j * 3
                if cellStates[x][y] && cellStates[x + 1][y] && cellStates[x + 2][y] &&
                    cellStates[x][y + 1] && cellStates[x + 1][y + 1] && cellStates[x + 2][y + 1] &&
                    cellStates[x][y + 2] && cellStates[x + 1][y + 2] && cellStates[x + 2][y + 2] {
                    positionsToClear.append(CellPosition(x: x, y: y))
                    positionsToClear.append(CellPosition(x: x + 1, y: y))
                    positionsToClear.append(CellPosition(x: x + 2, y: y))
                    positionsToClear.append(CellPosition(x: x, y: y + 1))
                    positionsToClear.append(CellPosition(x: x + 1, y: y + 1))
                    positionsToClear.append(CellPosition(x: x + 2, y: y + 1))
                    positionsToClear.append(CellPosition(x: x, y: y + 2))
                    positionsToClear.append(CellPosition(x: x + 1, y: y + 2))
                    positionsToClear.append(CellPosition(x: x + 2, y: y + 2))
                }
            }
        }
        
        return positionsToClear
    }
    
    private func clearCells(positionsToClear: [CellPosition]) {
        if positionsToClear.count > 0 {
            gameScene.removeCellNodesAnimated(positions: positionsToClear)
            for position in positionsToClear {
                cellStates[position.x][position.y] = false
            }
        }
    }
    
    private func updateScore(addedCells: Int, removedCells: Int) {
        score = scoreCalculator.calcScore(currentScore: score, addedCells: addedCells, removedCells: removedCells)
        gameScene.updateScore(score: score)
    }
    
    private func addFigures() {
        for i in 0 ..< Constants.NUMBER_OF_FIGURES {
            addNewFigure(position: i)
        }
    }
    
    private func checkFiguresDisabled() {
        var allFiguresDisabled = true
        for (i, figure) in figures.enumerated() {
            let figureFit = figure != nil ? isFigureFit(figure: figure!) : false
            if figureFit {
                allFiguresDisabled = false
            }
            
            gameScene.setFigureDisabled(disabled: !figureFit, position: i)
        }
        
        if allFiguresDisabled {
            gameOver()
        }
    }
    
    private func isFigureFit(figure: Figure) -> Bool {
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            for j in 0 ..< Constants.NUMBER_OF_CELLS {
                var isFit = true
                for point in figure.points {
                    if point.x + i < 0 || point.x + i >= Constants.NUMBER_OF_CELLS || point.y + j < 0 || point.y + j >= Constants.NUMBER_OF_CELLS || cellStates[point.x + i][point.y + j] {
                        isFit = false
                    }
                }
                if isFit {
                    return true
                }
            }
        }
        return false
    }
    
    private func gameOver() {
        let maxScore = storage.loadMaxScore()
        if score > maxScore {
            storage.saveMaxScore(score: score)
        }
        storage.deleteSavedGameState()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [unowned self] in
            self.gameScene.gameEnd()
        })
    }
    
    private func saveGameState() {
        var filledCellPositions: Set<CellPosition> = Set()
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            for j in 0 ..< Constants.NUMBER_OF_CELLS {
                if cellStates[i][j] {
                    filledCellPositions.insert(CellPosition(x: i, y: j))
                }
            }
        }
        let gameState = GameState(score: score, figures: figures, filledCellPositions: filledCellPositions)
        storage.saveGameState(state: gameState)
    }
    
    private func loadGameState() {
        if let savedGameState = storage.loadGameState() {
            self.score = savedGameState.score
            self.figures = savedGameState.figures
            for cellPosition in savedGameState.filledCellPositions {
                self.cellStates[cellPosition.x][cellPosition.y] = true
            }
            
            gameScene.updateScore(score: score)
            for (i, figure) in figures.enumerated() {
                if let figure = figure {
                    gameScene.addFigure(figure: figure, position: i)
                }
            }
            gameScene.addFilledCells(cellPositions: Array(savedGameState.filledCellPositions))
            checkFiguresDisabled()
        } else {
            initNewGame()
        }
    }
    
    private func loadMaxScore() {
        let maxScore = storage.loadMaxScore()
        gameScene.updateMaxScore(maxScore: maxScore)
    }
    
    private func initNewGame() {
        addFigures()
        checkFiguresDisabled()
    }
    
    private func addNewFigure(position: Int) {
        let figure = FigureCreator.createFigure()
        gameScene.addFigure(figure: figure, position: position)
        if figures.count > position {
            figures[position] = figure
        } else {
            figures.append(figure)
        }
    }
    
    private func filterCellPositions(positions: [CellPosition?]) -> [CellPosition] {
        var filteredPositions = [CellPosition]()
        for position in positions {
            if let position = position, filteredPositions.contains(position) == false,
                !cellStates[position.x][position.y] {
                filteredPositions.append(position)
            }
        }
        if filteredPositions.count == positions.count {
            return filteredPositions
        } else {
            return []
        }
    }
}
