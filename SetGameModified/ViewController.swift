//
//  ViewController.swift
//  SetGameModified
//
//  Created by Harsha on 26/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame()
    
    lazy var grid = Grid(layout: .dimensions(rowCount: Constants.initialRow, columnCount: Constants.initialColumn), frame: cardGridView.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetGrid()
    }
    
    @IBOutlet weak var cardGridView: PlayingCardView!
    
    @IBAction func dealMoreButtonTapped(_ sender: UIButton) {
        addMoreCard()
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        
    }
    
    private var allotedCards = [CardView]()
    
    private func loadInitialCards() {
        for counts in 0..<grid.cellCount {
            let frame = grid[counts]!
            let card = game.draw()
            
            let cardShow = CardView(shape: card!.shape.value, color: card!.color.value, number: card!.number.rawValue, shade: card!.shade.value, frame: frame)
            allotedCards.append(cardShow)
            cardGridView.addSubview(cardShow)
        }
    }

    private func resetGrid() {
        //clear earlier subviews
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount), frame: cardGridView.bounds)
        for counts in 0..<allotedCards.count {
            let frame = newgrid[counts]!
            let cardView = allotedCards[counts]
            let cardShow = CardView(shape: cardView.shape!, color: cardView.color!, number: cardView.number!, shade: cardView.shade!, frame: frame)
            cardGridView.addSubview(cardShow)
        }
        grid = newgrid
    }
    
    private func addMoreCard() {
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let noOfCell = grid.cellCount + Constants.noOfCardToDraw
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount + 1), frame: cardGridView.bounds)
        for counts in 0..<allotedCards.count {
            let frame = newgrid[counts]!
            let cardView = allotedCards[counts]
            let cardShow = CardView(shape: cardView.shape!, color: cardView.color!, number: cardView.number!, shade: cardView.shade!, frame: frame)
            cardGridView.addSubview(cardShow)
        }
        for counts in allotedCards.count..<noOfCell {
            let frame = newgrid[counts]!
            let card = game.draw()
            let cardShow = CardView(shape: card!.shape.value, color: card!.color.value, number: card!.number.rawValue, shade: card!.shade.value, frame: frame)
            allotedCards.append(cardShow)
            cardGridView.addSubview(cardShow)
        }
        grid = newgrid
    }
}

