//
//  FigureCreator.swift
//  BlocksGame
//
//  Created by Svetlana Gladysheva on 08/12/2019.
//  Copyright © 2019 Svetlana Gladysheva. All rights reserved.
//

import Foundation


class FigureCreator {
    
    static func createFigure() -> Figure {
        let index = Int(arc4random()) % Figure.allPossible.count
        return Figure.allPossible[index]
    }
    
}
