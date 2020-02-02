//
//  GameTest.swift
//  BlocksGameTests
//
//  Created by Svetlana Gladysheva on 23/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import XCTest
@testable import BlocksGame


class GameTest: XCTestCase {
    
    /*private var game: Game!
    
    private let figure1 = Figure(points: [CellPosition(x: 0, y: 0)])
    private let figure2 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0)])
    private let figure3 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 1), CellPosition(x: 1, y: 0), CellPosition(x: 2, y: 0)])
    private let figure4 = Figure(points: [CellPosition(x: 0, y: 0), CellPosition(x: 1, y: 0), CellPosition(x: 2, y: 0), CellPosition(x: -1, y: 0)])
    
    override func setUp() {
        game = Game()
    }
    
    func testIsFigureFit_EmptyField() {
        XCTAssertTrue(game.isFigureFit(figure: figure1))
        XCTAssertTrue(game.isFigureFit(figure: figure2))
        XCTAssertTrue(game.isFigureFit(figure: figure3))
        XCTAssertTrue(game.isFigureFit(figure: figure4))
    }
    
    func testIsFigureFit_FullField() {
        let filledCells = makeFullFieldCells()
        game.cellStates = filledCells
        
        XCTAssertFalse(game.isFigureFit(figure: figure1))
        XCTAssertFalse(game.isFigureFit(figure: figure2))
        XCTAssertFalse(game.isFigureFit(figure: figure3))
        XCTAssertFalse(game.isFigureFit(figure: figure4))
    }
    
    func testIsFigureFit_1() {
        var filledCells = makeFullFieldCells()
        filledCells[0][6] = false
        filledCells[0][7] = false
        filledCells[0][8] = false
        filledCells[1][7] = false
        game.cellStates = filledCells
        XCTAssertTrue(game.isFigureFit(figure: figure1))
        XCTAssertTrue(game.isFigureFit(figure: figure2))
        XCTAssertFalse(game.isFigureFit(figure: figure3))
        XCTAssertFalse(game.isFigureFit(figure: figure4))
    }
    
    private func makeFullFieldCells() -> [[Bool]] {
        var filledCells: [[Bool]] = []
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            filledCells.append([])
            for _ in 0 ..< Constants.NUMBER_OF_CELLS {
                filledCells[i].append(true)
            }
        }
        return filledCells
    }*/
    
}
