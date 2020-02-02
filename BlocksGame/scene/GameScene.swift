//
//  GameScene.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 19/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameSceneProtocol {
    
    private let game = Game()
    private var grid: Grid!
    private let scoreLabel = SKLabelNode()
    private let maxScoreLabel = SKLabelNode()
    private var draggedNode: FigureNode? = nil
    private var figureNodes: [FigureNode?] = []
    private var cellNodes = [[SKNode?]]()
    private var highlightedCellsPool = [SKNode]()
    private var cellSize: Int!
    private var smallCellSize: Int!
    
    var gameDelegate: GameSceneDelegate? = nil
    
    override func didMove(to view: SKView) {
        game.gameScene = self
        
        cellSize = (Int(frame.width) - 2 * Constants.PADDING) / Constants.NUMBER_OF_CELLS
        smallCellSize = Int(Double(cellSize) * 0.6)
        
        backgroundColor = UIColor(named: "BgColor")!
        addGrid()
        addScoreLabel()
        addMaxScoreLabel()
        
        for i in 0 ..< Constants.NUMBER_OF_CELLS {
            cellNodes.append([])
            for _ in 0 ..< Constants.NUMBER_OF_CELLS {
                cellNodes[i].append(nil)
            }
        }
        
        for _ in 0 ..< Constants.MAX_FIGURE_CELLS_COUNT {
            let cellNode = createCellNode(position: CellPosition(x: 0, y: 0), color: UIColor(named: "HighlightedCellColor")!)
            cellNode.isHidden = true
            highlightedCellsPool.append(cellNode)
        }
        
        for _ in 0 ..< Constants.NUMBER_OF_FIGURES {
            figureNodes.append(nil)
        }
        
        game.onLoad()
    }
    
    private func addGrid() {
        grid = Grid(cellSize: CGFloat(cellSize), rows: Constants.NUMBER_OF_CELLS, cols: Constants.NUMBER_OF_CELLS)!
        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(grid)
    }
    
    private func addScoreLabel() {
        scoreLabel.position = CGPoint(x: frame.midX, y: size.height - (size.height - grid.size.height) / 4)
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 26
        scoreLabel.fontName = "Verdana"
        
        addChild(scoreLabel)
        
        updateScore(score: 0)
    }
    
    private func addMaxScoreLabel() {
        let maxScoreNode = SKNode()
        
        let scoreImageNode = SKSpriteNode.init(imageNamed: "score")
        scoreImageNode.position = CGPoint(x: 0, y: 0)
        maxScoreNode.addChild(scoreImageNode)
        
        maxScoreLabel.position = CGPoint(x: scoreImageNode.size.width + 8, y: 0)
        maxScoreLabel.fontColor = UIColor.black
        maxScoreLabel.fontSize = 16
        maxScoreLabel.fontName = "Verdana"
        maxScoreLabel.verticalAlignmentMode = .center
        maxScoreNode.addChild(maxScoreLabel)
        
        let x = grid.position.x - (grid.size.width - scoreImageNode.frame.width) / 2
        let y = grid.position.y + grid.size.height / 2 + 30
        maxScoreNode.position = CGPoint(x: x, y: y)
        addChild(maxScoreNode)
    }
    
    func addFigure(figure: Figure, position: Int) {
        let figureNode = FigureNode(figure: figure, figureNumber: position, cellSize: smallCellSize)
        
        figureNode.position = getPositionForNewFigure(figureNode: figureNode)
        self.addChild(figureNode)
        
        figureNodes[position] = figureNode
    }
    
    func setFigureDisabled(disabled: Bool, position: Int) {
        if let figureNode = figureNodes[position] {
            figureNode.setDisabled(disabled: disabled)
        }
    }
    
    func addFilledCells(cellPositions: [CellPosition]) {
        for point in cellPositions {
            let x = point.x
            let y = point.y
            cellNodes[x][y] = createCellNode(position: CellPosition(x: x, y: y), color: UIColor(named: "CellColor")!)
        }
    }
    
    func highlightCells(cellPositions: [CellPosition]) {
        for (index, position) in cellPositions.enumerated() {
            highlightedCellsPool[index].position = grid.gridPosition(row: position.x, col: position.y)
            highlightedCellsPool[index].isHidden = false
        }
        for i in cellPositions.count ..< highlightedCellsPool.count {
            highlightedCellsPool[i].isHidden = true
        }
    }
    
    func updateScore(score: Int) {
        scoreLabel.text = "\(score)"
    }
    
    func removeFigure(position: Int) {
        figureNodes[position]?.removeFromParent()
        figureNodes[position] = nil
    }
    
    func moveFigureToInitialPosition(position: Int) {
        if let figureNode = figureNodes[position] {
            figureNode.position = getPositionForNewFigure(figureNode: figureNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes {
                if let figureNode = node as? FigureNode, !figureNode.isDisabled, let position = figureNodes.firstIndex(of: figureNode) {
                    self.draggedNode = figureNode
                    game.onFigureDragBegan(position: position)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = draggedNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
            
            var figureCellPositions: [CellPosition?] = []
            for figureNode in node.children {
                let position = getCellPosition(figureNode: figureNode, grid: grid)
                figureCellPositions.append(position)
            }
            
            game.onFigureMoved(cellPositions: figureCellPositions)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchFinished()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchFinished()
    }
    
    private func onTouchFinished() {
        if let figureNode = draggedNode {
            var figureCellPositions: [CellPosition] = []
            for figureChildNode in figureNode.children {
                if let position = getCellPosition(figureNode: figureChildNode, grid: grid) {
                    figureCellPositions.append(position)
                }
            }
            game.onFigureDropped(cellPositions: figureCellPositions, figureNumber: figureNode.figureNumber)
        }
        self.draggedNode = nil
    }
    
    func removeCellNodesAnimated(positions: [CellPosition]) {
        let containerNode = SKNode()
        grid.addChild(containerNode)
        
        for position in positions {
            if let node = cellNodes[position.x][position.y] {
                node.removeFromParent()
                containerNode.addChild(node)
            }
            cellNodes[position.x][position.y] = nil
        }
        
        let disappear = SKAction.fadeOut(withDuration: 0.1)
        let appear  = SKAction.fadeIn(withDuration: 0.1)
        let clearAnimation = SKAction.sequence([disappear, appear, disappear, appear])
        containerNode.run(clearAnimation) {
            containerNode.removeFromParent()
        }
    }
    
    func increaseFigure(position: Int) {
        figureNodes[position]?.changeCellSize(cellSize: cellSize)
    }
    
    func decreaseFigure(position: Int) {
        figureNodes[position]?.changeCellSize(cellSize: smallCellSize)
    }
    
    func gameEnd() {
        gameDelegate?.showGameOverScene()
    }
    
    func updateMaxScore(maxScore: Int) {
        maxScoreLabel.text = "\(maxScore)"
    }
    
    private func getCellPosition(figureNode: SKNode, grid: Grid) -> CellPosition? {
        let centerX = figureNode.position.x + (figureNode.parent?.position.x ?? 0)
        let centerY = figureNode.position.y + (figureNode.parent?.position.y ?? 0)
        return grid.getCellPosition(position: CGPoint(x: centerX, y: centerY))
    }
    
    private func getPositionForNewFigure(figureNode: FigureNode) -> CGPoint {
        let gridHeight = grid?.size.height ?? 0
        let xOffset = calcOffsetX(figure: figureNode.figure)
        let yOffset = calcOffsetY(figure: figureNode.figure)
        let x = CGFloat(figureNode.figureNumber + 1) * frame.size.width / 3 - frame.size.width / 6
        let y = (size.height - gridHeight / 2 - frame.midY) / 2
        return CGPoint(x: x - CGFloat(xOffset), y: y - CGFloat(yOffset))
    }
    
    private func createCellNode(position: CellPosition, color: UIColor) -> SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: cellSize, height: cellSize))
        node.fillColor = color
        node.position = grid.gridPosition(row: position.x, col: position.y)
        grid.addChild(node)
        return node
    }
    
    private func calcOffsetX(figure: Figure) -> Int {
        var setX: Set<Int> = Set()
        for cellPosition in figure.points {
            setX.insert(cellPosition.x)
        }
        let diff = (setX.max() ?? 0) + (setX.min() ?? 0)
        return diff * (smallCellSize / 2)
    }
    
    private func calcOffsetY(figure: Figure) -> Int {
        var setY: Set<Int> = Set()
        for cellPosition in figure.points {
            setY.insert(cellPosition.y)
        }
        let diff = (setY.max() ?? 0) + (setY.min() ?? 0)
        return diff * (smallCellSize / 2)
    }

}
