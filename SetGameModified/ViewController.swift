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
    
    lazy var grid = Grid(layout: .dimensions(rowCount: Constants.Game.initialRow, columnCount: Constants.Game.initialColumn), frame: cardGridView.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetGrid()
    }
    
    @IBOutlet weak var cardGridView: PlayingCardView!
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var scoreCardLabel: UILabel!
    
    
    @IBAction func dealMoreButtonTapped(_ sender: UIButton) {
        addMoreCard()
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    private var allotedCards = [CardView]()
    private var selectedCards = [CardView]() { didSet { checkForSet() } }
    
    private func checkForSet() {
        if selectedCards.count == 3 {
            var cards = [Card]()
            for cardview in selectedCards {
                cards.append(cardview.card)
            }
            let isSet = game.containsSet(in: cards)
            if isSet {
                for cardview in selectedCards {
                    if allotedCards.firstIndex(of: cardview) == nil {
                        print("Value is nil")
                    }
                    if let index = allotedCards.firstIndex(of: cardview) {
                        allotedCards.remove(at: index)
                        replaceCard(at: index, with: cardview)
                    }
                }
            }
            for _ in 0..<selectedCards.count {
                selectedCards.remove(at: 0)
            }
        }
    }
    
    private func replaceCard(at index: Int, with cardview: CardView) {
        let card = game.draw()
        let cardShow = CardView(frame: grid[index]!, card: card!)
        //cardGridView.willRemoveSubview(cardview)
        cardGridView.insertSubview(cardShow, at: index)
        allotedCards.insert(cardShow, at: index)
    }
    
    private func loadInitialCards() {
        for counts in 0..<grid.cellCount {
            let frame = grid[counts]!
            let card = game.draw()
            
            let cardShow = CardView(frame: frame, card: card!)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            allotedCards.append(cardShow)
            cardGridView.addSubview(cardShow)
        }
        dealMoreButton.backgroundColor = Constants.Color.backgroundColor
        dealMoreButton.setTitle("DEAL MORE BUTTON", for: .normal)
        dealMoreButton.setTitleColor(Constants.Color.fontColor, for: .normal)
        hintButton.backgroundColor = Constants.Color.backgroundColor
        hintButton.setTitle("HINT", for: .normal)
        hintButton.setTitleColor(Constants.Color.fontColor, for: .normal)
        scoreCardLabel.text = "SCORE: \(game.score)"
        scoreCardLabel.backgroundColor = Constants.Color.backgroundColor
    }

    private func resetGrid() {
        //clear earlier subviews
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount), frame: cardGridView.bounds)
        for counts in 0..<allotedCards.count {
            let frame = newgrid[counts]!
            let card = allotedCards[counts].card
            let cardShow = CardView(frame: frame, card: card)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            cardGridView.addSubview(cardShow)
        }
        grid = newgrid
    }

    private func addMoreCard() {
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let noOfCell = grid.cellCount + Constants.Game.noOfCardToDraw
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount + 1), frame: cardGridView.bounds)
        for counts in 0..<allotedCards.count {
            let frame = newgrid[counts]!
            let card = allotedCards[counts].card
            let cardShow = CardView(frame: frame, card: card)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            cardGridView.addSubview(cardShow)
        }
        for counts in allotedCards.count..<noOfCell {
            let frame = newgrid[counts]!
            let card = game.draw()
            let cardShow = CardView(frame: frame, card: card!)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            allotedCards.append(cardShow)
            cardGridView.addSubview(cardShow)
        }
        grid = newgrid
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? CardView {
            if cardView.selected {
                if let index = selectedCards.firstIndex(of: cardView) {
                    selectedCards.remove(at: index)
                }
            } else {
                selectedCards.append(cardView)
            }
            cardView.selected = !cardView.selected
        }
    }
}

