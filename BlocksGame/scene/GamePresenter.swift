//
//  GamePresenter.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 19/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class GamePresenter {
    
    var gameView: GameViewProtocol!
    private let storage = Storage()
    private let gameField = GameField(rows: Constants.NUMBER_OF_CELLS, cols: Constants.NUMBER_OF_CELLS)
    private let scoreCalculator = ScoreCalculator()
    private var figures: [Figure?] = []
    private var score = 0
    
    func onLoad() {
        loadGameState()
        loadMaxScore()
    }
    
    func onFigureDragBegan(position: Int) {
        gameView.increaseFigure(position: position)
    }
    
    func onFigureMoved(figure: Figure, cellPosition: CellPosition?) {
        guard let cellPosition = cellPosition else {
            gameView.highlightCells(cellPositions: [])
            return
        }
        
        if gameField.isFigureFit(figure: figure, cellPosition: cellPosition) {
            var cellPositions: [CellPosition] = []
            for point in figure.points {
                cellPositions.append(CellPosition(x: cellPosition.x + point.x, y: cellPosition.y + point.y))
            }
            gameView.highlightCells(cellPositions: cellPositions)
        } else {
            gameView.highlightCells(cellPositions: [])
        }
    }
    
    func onFigureDropped(figure: Figure, cellPosition: CellPosition?, figureNumber: Int) {
        let step = gameField.addFigure(figure: figure, cellPosition: cellPosition)
        
        if step.added.count > 0 {
            gameView.addFilledCells(cellPositions: step.added)
            
            gameView.removeFigure(position: figureNumber)
            
            figures[figureNumber] = nil
            if !figures.contains(where: {$0 != nil}) {
                addFigures()
            }
            
            clearCells(positionsToClear: step.removed)
            
            updateScore(addedCells: step.added.count, removedCells: step.removed.count)
            
            saveGameState()
            checkFiguresDisabled()
            
        } else {
            gameView.moveFigureToInitialPosition(position: figureNumber)
            gameView.decreaseFigure(position: figureNumber)
        }
        
        gameView.highlightCells(cellPositions: [])
    }
    
    private func clearCells(positionsToClear: [CellPosition]) {
        if positionsToClear.count > 0 {
            gameView.removeCellNodesAnimated(positions: positionsToClear)
        }
    }
    
    private func updateScore(addedCells: Int, removedCells: Int) {
        score = scoreCalculator.calcScore(currentScore: score, addedCells: addedCells, removedCells: removedCells)
        gameView.updateScore(score: score)
    }
    
    private func addFigures() {
        for i in 0 ..< Constants.NUMBER_OF_FIGURES {
            addNewFigure(position: i)
        }
    }
    
    private func checkFiguresDisabled() {
        var allFiguresDisabled = true
        for (i, figure) in figures.enumerated() {
            let figureFit = figure != nil ? gameField.isFigureFit(figure: figure!) : false
            if figureFit {
                allFiguresDisabled = false
            }
            
            gameView.setFigureDisabled(disabled: !figureFit, position: i)
        }
        
        if allFiguresDisabled {
            gameOver()
        }
    }
    
    private func gameOver() {
        let maxScore = storage.loadMaxScore()
        if score > maxScore {
            storage.saveMaxScore(score: score)
        }
        storage.deleteSavedGameState()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [unowned self] in
            self.gameView.gameEnd()
        })
    }
    
    private func saveGameState() {
        let gameState = GameState(score: score, figures: figures, filledCellPositions: Set(gameField.getFilledCellPositions()))
        storage.saveGameState(state: gameState)
    }
    
    private func loadGameState() {
        if let savedGameState = storage.loadGameState() {
            self.score = savedGameState.score
            self.figures = savedGameState.figures
            gameField.setFilledCellPositions(filledCellPositions: Array(savedGameState.filledCellPositions))
            
            gameView.updateScore(score: score)
            for (i, figure) in figures.enumerated() {
                if let figure = figure {
                    gameView.addFigure(figure: figure, position: i)
                }
            }
            gameView.addFilledCells(cellPositions: Array(savedGameState.filledCellPositions))
            checkFiguresDisabled()
        } else {
            initNewGame()
        }
    }
    
    private func loadMaxScore() {
        let maxScore = storage.loadMaxScore()
        gameView.updateMaxScore(maxScore: maxScore)
    }
    
    private func initNewGame() {
        addFigures()
        checkFiguresDisabled()
    }
    
    private func addNewFigure(position: Int) {
        let figure = FigureCreator.createFigure()
        gameView.addFigure(figure: figure, position: position)
        if figures.count > position {
            figures[position] = figure
        } else {
            figures.append(figure)
        }
    }
}
