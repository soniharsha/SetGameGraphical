//
//  ViewController.swift
//  SetGameModified
//
//  Created by Harsha on 26/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame ()
    lazy var swipeGestureRecogniser: UISwipeGestureRecognizer = {
        let swipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(addMoreCard))
        swipeGestureRecogniser.direction = [.down]
        
        return swipeGestureRecogniser
    }()
    
    lazy var grid = Grid(layout: .dimensions(rowCount: Constants.Game.initialRow, columnCount: Constants.Game.initialColumn), frame: cardGridView.bounds)
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInitialCards()
    }
    
    @IBOutlet weak var cardGridView: PlayingCardView! {
        didSet {
            cardGridView.addGestureRecognizer(swipeGestureRecogniser)
        }
    }
    
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var scoreCardLabel: UILabel!
    
    @IBAction func dealMoreButtonTapped(_ sender: UIButton) {
        addMoreCard()
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        deselect()
        game.hintEnabled = true
        var found = false
        for firstCard in 0..<allotedCards.count {
            for secondCard in (firstCard+1)..<allotedCards.count {
                for thirdCard in (secondCard+1)..<allotedCards.count {
                    if game.containsSet(in: [allotedCards[firstCard].card, allotedCards[secondCard].card, allotedCards[thirdCard].card]) {
                        allotedCards[firstCard].hint = true
                        allotedCards[secondCard].hint = true
                        allotedCards[thirdCard].hint = true
                        found = true
                        break
                    }
                }
                if found {
                    break
                }
            }
            if found {
                break
            }
        }
        game.hintEnabled = false
    }
    
    private var allotedCards = [CardView]()
    private var totalUsedCards = Constants.Game.initialRow * Constants.Game.initialColumn { didSet { disableAddition() } }
    private var selectedCards = [CardView]() { didSet { checkForSet() } }
    
    private func scoreCardChange() {
        scoreCardLabel.text = "SCORE: \(game.score)"
    }
    
    private func disableAddition() {
        if totalUsedCards >= Constants.Game.totalCard {
            dealMoreButton.isEnabled = false
            cardGridView.removeGestureRecognizer(swipeGestureRecogniser)
        }
    }
    
    private func deselect() {
        for cardview in selectedCards {
            if let index = allotedCards.firstIndex(of: cardview) {
                allotedCards[index].selected = !allotedCards[index].selected
            }
        }
        for _ in 0..<selectedCards.count {
            game.deselectionPenalty()
            selectedCards.remove(at: 0)
        }
        scoreCardChange()
    }
    
    private func checkForSet() {
        if selectedCards.count == Constants.Game.noOfCardToDraw {
            var cards = [Card]()
            for cardview in selectedCards {
                cards.append(cardview.card)
            }
            let isSet = game.containsSet(in: cards)
            if isSet {
                for cardview in selectedCards {
                    if let index = allotedCards.firstIndex(of: cardview) {
                        allotedCards.remove(at: index)
                    }
                }
                showResult.text = "YAY! A SET"
                addMoreCard()
            } else {
                showResult.text = "OOPS! WRONG SET"
                for cardview in selectedCards {
                    if let index = allotedCards.firstIndex(of: cardview) {
                        allotedCards[index].selected = !allotedCards[index].selected
                    }
                }
            }
            for _ in 0..<selectedCards.count {
                selectedCards.remove(at: 0)
            }
            scoreCardChange()
            for cardView in allotedCards {
                cardView.hint = false
            }
        }
    }
    
    private func loadInitialCards() {
        totalUsedCards = grid.cellCount
        for counts in 0..<grid.cellCount {
            let frame = grid[counts]!
            let card = game.draw()
            let cardShow = CardView(frame: frame, card: card!, selected: false, hint: false)
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
        showResult.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count) CARDS NEEDED"
    }

    private func resetGrid() {
        //clear earlier subviews
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount), frame: cardGridView.bounds)
        
        for count in 0..<allotedCards.count {
            
            let frame = newgrid[count]!
            let cardShow = CardView(frame: frame, card: allotedCards[count].card, selected: allotedCards[count].selected, hint: allotedCards[count].hint)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            if let cardIndexInSelected = selectedCards.firstIndex(of: allotedCards[count]) {
                selectedCards[cardIndexInSelected] = cardShow
            }
            allotedCards[count] = cardShow
            cardGridView.addSubview(cardShow)
        }
        grid = newgrid
    }

    @objc private func addMoreCard() {
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        var noOfCell = allotedCards.count
        if totalUsedCards <= Constants.Game.totalCard {
            noOfCell += Constants.Game.noOfCardToDraw
        }
        var noOfRow = Int(sqrt(Double(noOfCell)))
        var noOfCol = noOfRow
        while (noOfRow * noOfCol < noOfCell) {
            if noOfRow == noOfCol {
                noOfRow += 1
            } else {
                noOfCol += 1
            }
        }
        let newgrid = Grid(layout: .dimensions(rowCount: noOfRow, columnCount: noOfCol), frame: cardGridView.bounds)
        for count in 0..<allotedCards.count {
            let frame = newgrid[count]!
            let cardShow = CardView(frame: frame, card: allotedCards[count].card, selected: allotedCards[count].selected, hint: allotedCards[count].hint)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
            cardShow.addGestureRecognizer(tap)
            if let cardIndexInSelected = selectedCards.firstIndex(of: allotedCards[count]) {
                selectedCards[cardIndexInSelected] = cardShow
            }
            allotedCards[count] = cardShow
            cardGridView.addSubview(cardShow)
        }
        totalUsedCards += Constants.Game.noOfCardToDraw
        
        if totalUsedCards <= Constants.Game.totalCard {
            for counts in allotedCards.count..<noOfCell {
                let frame = newgrid[counts]!
                let card = game.draw()
                let cardShow = CardView(frame: frame, card: card!, selected: false, hint: false)
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
                cardShow.addGestureRecognizer(tap)
                allotedCards.append(cardShow)
                cardGridView.addSubview(cardShow)
            }
        }
        grid = newgrid
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        showResult.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count - 1) CARDS NEEDED"
        if let cardView = sender.view as? CardView {
            if cardView.selected {
                if let index = selectedCards.firstIndex(of: cardView) {
                    selectedCards.remove(at: index)
                }
                game.deselectionPenalty()
                scoreCardChange()
                showResult.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count) CARDS NEEDED"
            } else {
                selectedCards.append(cardView)
            }
            cardView.hint = false
            cardView.selected = !cardView.selected
        }
    }
}

