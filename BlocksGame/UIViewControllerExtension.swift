//
//  UIViewControllerExtension.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 24/01/2020.
//  Copyright © 2020 Svetlana Gladysheva. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func setBackgroundGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.white.cgColor, UIColor.init(red: 0.4, green: 0.6, blue: 1, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
}
