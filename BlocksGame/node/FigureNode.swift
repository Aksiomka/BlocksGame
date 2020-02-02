//
//  FigureNode.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 20/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation
import SpriteKit


class FigureNode: SKNode {
    
    let figure: Figure
    let figureNumber: Int
    var isDisabled = false
    
    init(figure: Figure, figureNumber: Int, cellSize: Int) {
        self.figure = figure
        self.figureNumber = figureNumber
        super.init()
        
        for point in figure.points {
            let figureCell = SKShapeNode(rectOf: CGSize(width: cellSize, height: cellSize))
            figureCell.strokeColor = UIColor.black
            figureCell.position = CGPoint(x: point.x * cellSize, y: point.y * cellSize)
            
            addChild(figureCell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCellSize(cellSize: Int) {
        for (i, point) in figure.points.enumerated() {
            let newPoint = CGPoint(x: point.x * cellSize, y: point.y * cellSize)
            let moveAction = SKAction.move(to: newPoint, duration: TimeInterval(0.3))
            children[i].run(SKAction.group([moveAction]))
        }
    }
    
    func setDisabled(disabled: Bool) {
        isDisabled = disabled
        for node in children {
            (node as? SKShapeNode)?.fillColor = disabled ? UIColor.gray : UIColor.blue
        }
    }
    
}
