//
//  ViewController.swift
//  SetGameModified
//
//  Created by Harsha on 26/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardGridView: PlayingCardView!
    
    var game = SetGame()
    var grid = Grid(layout: .dimensions(rowCount: Constants.initialRow, columnCount: Constants.initialColumn))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadInitialCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetGrid()
    }
    
//    func loadInitialCards() {
//        for counts in 0..<grid.cellCount {
//            let frame = grid[counts]!
//
//        }
//    }
    
    func resetGrid() {
        let cardsInARow = 4
        let rows = 3
        grid = Grid(layout: .dimensions(rowCount: rows, columnCount: cardsInARow), frame: cardGridView.bounds)
        for i in 0..<grid.cellCount {
            let frame = grid[i]!
            let card = CardView(frame: frame)
            cardGridView.addSubview(card) 
        }
    }
}

