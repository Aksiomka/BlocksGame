//
//  Grid.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 08/12/2019.
//  Copyright © 2019 Svetlana Gladysheva. All rights reserved.
//

import UIKit
import SpriteKit


class Grid: SKSpriteNode {
    private var rows: Int!
    private var cols: Int!
    private var cellSize: CGFloat!

    convenience init?(cellSize: CGFloat, rows: Int, cols: Int) {
        guard let texture = Grid.gridTexture(cellSize: cellSize, rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.cellSize = cellSize
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = true
        
        createBgNodes()
    }

    class func gridTexture(cellSize: CGFloat, rows: Int, cols: Int) -> SKTexture? {
        // Add 2 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols) * cellSize + 2.0, height: CGFloat(rows) * cellSize + 2.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let offset: CGFloat = 1
        
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.black.cgColor)
        for i in 0...cols {
            let x = CGFloat(i) * cellSize + offset
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: size.height))
        }
        for i in 0...rows {
            let y = CGFloat(i) * cellSize + offset
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: size.width, y: y))
        }
        context.strokePath()
        
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.black.cgColor)
        for i in 0...cols/3 {
            let x = 3 * CGFloat(i) * cellSize + offset
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: size.height))
        }
        for i in 0...rows/3 {
            let y = 3 * CGFloat(i) * cellSize + offset
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: size.width, y: y))
        }
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row: Int, col: Int) -> CGPoint {
        let offset = cellSize / 2.0 + 0.5
        let x = CGFloat(row) * cellSize - (cellSize * CGFloat(rows)) / 2.0 + offset
        let y = CGFloat(col) * cellSize - (cellSize * CGFloat(cols)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
    
    func getCellPosition(position: CGPoint) -> CellPosition? {
        let row = Int((position.x - self.position.x + self.frame.width / 2) / cellSize)
        let col = Int((position.y - self.position.y + self.frame.height / 2) / cellSize)
        if row < 0 || row >= rows || col < 0 || col >= cols {
            return nil
        }
        return CellPosition(x: row, y: col)
    }
    
    private func createBgNodes() {
        createBgNode(x: 0, y: 0)
        createBgNode(x: 3 * cellSize, y: 3 * cellSize)
        createBgNode(x: -3 * cellSize, y: 3 * cellSize)
        createBgNode(x: 3 * cellSize, y: -3 * cellSize)
        createBgNode(x: -3 * cellSize, y: -3 * cellSize)
    }
    
    private func createBgNode(x: CGFloat, y: CGFloat) {
        let bgNode = SKSpriteNode(color: UIColor(named: "GridBgColor")!, size: CGSize(width: 3 * cellSize, height: 3 * cellSize))
        bgNode.position = CGPoint(x: x, y: y)
        addChild(bgNode)
    }
}
