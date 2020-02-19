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
    
    private func setBackgroundGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.white.cgColor, UIColor.init(red: 0.4, green: 0.6, blue: 1, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
    }
}

