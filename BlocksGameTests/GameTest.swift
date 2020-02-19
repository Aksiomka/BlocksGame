//
//  GameTest.swift
//  BlocksGameTests
//
//  Created by Svetlana Gladysheva on 23/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import XCTest
@testable import BlocksGame


class GameFieldTest: XCTestCase {
    
    private var gameField: GameField!
    
    private let figure1 = Figure(points: [CellPosition(x: 0, y: 0)])
    private let figure2 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0)])
    private let figure3 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 1), CellPosition(x: 1, y: 0), CellPosition(x: 2, y: 0)])
    private let figure4 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0), CellPosition(x: 2, y: 0), CellPosition(x: -1, y: 0)])
    
    override func setUp() {
        gameField = GameField(rows: 9, cols: 9)
    }
    
    func testIsFigureFit_EmptyField() {
        XCTAssertTrue(gameField.isFigureFit(figure: figure1))
        XCTAssertTrue(gameField.isFigureFit(figure: figure2))
        XCTAssertTrue(gameField.isFigureFit(figure: figure3))
        XCTAssertTrue(gameField.isFigureFit(figure: figure4))
    }
    
    func testIsFigureFit_FullField() {
        gameField.setFilledCellPositions(filledCellPositions: makeFullFieldCellPositions())
        
        XCTAssertFalse(gameField.isFigureFit(figure: figure1))
        XCTAssertFalse(gameField.isFigureFit(figure: figure2))
        XCTAssertFalse(gameField.isFigureFit(figure: figure3))
        XCTAssertFalse(gameField.isFigureFit(figure: figure4))
    }
    
    func testIsFigureFit_OneCellLeft() {
        var cellPositions = makeFullFieldCellPositions()
        cellPositions.removeLast()
        gameField.setFilledCellPositions(filledCellPositions: cellPositions)
        
        XCTAssertTrue(gameField.isFigureFit(figure: figure1))
        XCTAssertFalse(gameField.isFigureFit(figure: figure2))
        XCTAssertFalse(gameField.isFigureFit(figure: figure3))
        XCTAssertFalse(gameField.isFigureFit(figure: figure4))
    }
    
    func testIsFigureFit_OneColumnLeft() {
        var cellPositions = makeFullFieldCellPositions()
        cellPositions.removeAll(where: { $0.y == 3 })
        gameField.setFilledCellPositions(filledCellPositions: cellPositions)
        
        XCTAssertTrue(gameField.isFigureFit(figure: figure1))
        XCTAssertTrue(gameField.isFigureFit(figure: figure2))
        XCTAssertFalse(gameField.isFigureFit(figure: figure3))
        XCTAssertTrue(gameField.isFigureFit(figure: figure4))
    }
    
    private func makeFullFieldCellPositions() -> [CellPosition] {
        var cellPositions: [CellPosition] = []
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            for j in 0 ..< Constants.NUMBER_OF_CELLS {
                cellPositions.append(CellPosition(x: i, y: j))
            }
        }
        return cellPositions
    }
    
}
