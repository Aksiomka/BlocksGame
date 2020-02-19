//
//  GameViewController.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 07/12/2019.
//  Copyright © 2019 Svetlana Gladysheva. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate, GameOverSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let view = self.view as! SKView
        let scene = GameScene(size: view.bounds.size)
        scene.gameDelegate = self
        view.ignoresSiblingOrder = true
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    func gameOver() {
        let skView = view as! SKView
        let gameOverScene = GameOverScene(size: view.bounds.size)
        gameOverScene.gameDelegate = self
        skView.presentScene(gameOverScene)
    }
    
    func gameEnd() {
        self.navigationController?.popViewController(animated: true)
    }
}
