//
//  GameSceneProtocol.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 19/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation


protocol GameSceneProtocol {
    func addFigure(figure: Figure, position: Int)
    func setFigureDisabled(disabled: Bool, position: Int)
    func addFilledCells(cellPositions: [CellPosition])
    func highlightCells(cellPositions: [CellPosition])
    func updateScore(score: Int)
    func removeFigure(position: Int)
    func moveFigureToInitialPosition(position: Int)
    func removeCellNodesAnimated(positions: [CellPosition])
    func increaseFigure(position: Int)
    func decreaseFigure(position: Int)
    func gameEnd()
    func updateMaxScore(maxScore: Int)
}
