//
//  StartViewController.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 17/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import UIKit


class StartViewController: UIViewController {
    
    @IBOutlet private weak var startGameButton: UIButton!
    @IBOutlet private weak var resumeGameButton: UIButton!
    @IBOutlet private weak var maxScoreLabel: UILabel!
    
    private let storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedGameState = storage.loadGameState()
        resumeGameButton.isHidden = savedGameState == nil
        
        updateMaxScore()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func onStartGameButtonClick(_ sender: UIButton) {
        storage.deleteSavedGameState()
        showGameViewController()
    }
    
    @IBAction func onResumeGameButtonClick(_ sender: UIButton) {
        showGameViewController()
    }
    
    private func showGameViewController() {
        let gameViewController = GameViewController()
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    private func updateMaxScore() {
        let maxScore = storage.loadMaxScore()
        maxScoreLabel.text = "\(maxScore)"
    }
}

