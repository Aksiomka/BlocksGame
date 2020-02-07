//
//  GameOverScene.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 17/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import Foundation
import SpriteKit


protocol GameOverSceneDelegate {
    func gameEnd()
}

class GameOverScene: SKScene {
    
    var gameDelegate: GameOverSceneDelegate? = nil
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let message = "Game over"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                self?.gameDelegate?.gameEnd()
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
