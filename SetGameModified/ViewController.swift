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
    
//    lazy var cardBehavior = CardBehavior(in: animator)
//    lazy var animator = UIDynamicAnimator(referenceView: view)
//    lazy var behavior = CardBehavior(in: animator)
    
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
    @IBOutlet weak var resultLabel: UILabel!
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
                        animateHintCards([allotedCards[firstCard],allotedCards[secondCard],allotedCards[thirdCard]])
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
    
    private func animateHintCards(_ cardviews: [CardView]) {
        for cardview in cardviews {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            cardview.hint = true
                            cardview.alpha = 0.8
            },
                           completion: {completion in
                             cardview.hint = false
                             cardview.alpha = 1.0
            })
        }
    }
    
    private func setAnimation(in cards: [Card]) {
        UIView.transition(with: resultLabel,
                          duration: 2,
                          options: .transitionCurlUp,
                          animations: { [weak self] in
                            self?.resultLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.Game.scoreCardAnimatedSize))
                            self?.resultLabel.alpha = 1.0
                          },
                          completion: { completion in
                            self.resultLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.Game.scoreCardTextSize))
                            self.resultLabel.alpha = 1.0
                          })
    }
    
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
    
    private func addAnimation(withDelay delay: Double, in frame: CGRect, on cardview: CardView) {
        UIView.animate(withDuration: Constants.Game.loadCardDuration, delay: delay, options: [], animations: {
            cardview.frame = frame
        }, completion: nil)
    }
    
    private func addGesture(on cardview: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        cardview.addGestureRecognizer(tap)
    }
    
    private func checkForSet() {
        if selectedCards.count == Constants.Game.noOfCardToDraw {
            var cards = [Card]()
            for cardview in selectedCards {
                cards.append(cardview.card)
            }
            let isSet = game.containsSet(in: cards)
            if isSet {
                resultLabel.text = "YAY! A SET"
                setAnimation(in: cards)
                for cardview in selectedCards {
                    if let index = allotedCards.firstIndex(of: cardview) {
                        allotedCards.remove(at: index)
                    }
                }
                addMoreCard()
            } else {
                resultLabel.text = "OOPS! WRONG SET"
                setAnimation(in: cards)
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
            
        }
    }
    
    private func loadInitialCards() {
        totalUsedCards = grid.cellCount
        for index in 0..<grid.cellCount {
            let frame = grid[index]!
            let card = game.draw()
            let subFrame = view.convert(dealMoreButton.frame, to: cardGridView)
            let cardShow = CardView(frame: CGRect(x: subFrame.midX, y: subFrame.midY, width: frame.width, height: frame.height), card: card!, selected: false)
            addAnimation(withDelay: Constants.Game.delayBetweenCards, in: frame, on: cardShow)
            addGesture(on: cardShow)
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
        resultLabel.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count) CARDS NEEDED"
        resultLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.Game.scoreCardTextSize))
    }

    private func resetGrid() {
        //clear earlier subviews
        for view in cardGridView.subviews {
            view.removeFromSuperview()
        }
        let newgrid = Grid(layout: .dimensions(rowCount: grid.dimensions.columnCount, columnCount: grid.dimensions.rowCount), frame: cardGridView.bounds)
        
        for index in 0..<allotedCards.count {
            
            let frame = newgrid[index]!
            let cardShow = CardView(frame: CGRect(x: dealMoreButton.frame.midX, y: dealMoreButton.frame.midY, width: frame.width, height: frame.height), card: allotedCards[index].card, selected: allotedCards[index].selected)
            addAnimation(withDelay: Constants.Game.delayBetweenCards, in: frame, on: cardShow)
            addGesture(on: cardShow)
            if let cardIndexInSelected = selectedCards.firstIndex(of: allotedCards[index]) {
                selectedCards[cardIndexInSelected] = cardShow
            }
            allotedCards[index] = cardShow
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
        for index in 0..<allotedCards.count {
            let frame = newgrid[index]!
            let oldFrame = allotedCards[index].frame
            let cardShow = CardView(frame: oldFrame, card: allotedCards[index].card, selected: allotedCards[index].selected)
            addAnimation(withDelay: Constants.Game.delayBetweenCards, in: frame, on: cardShow)
            addGesture(on: cardShow)
            if let cardIndexInSelected = selectedCards.firstIndex(of: allotedCards[index]) {
                selectedCards[cardIndexInSelected] = cardShow
            }
            allotedCards[index] = cardShow
            cardGridView.addSubview(cardShow)
        }
        totalUsedCards += Constants.Game.noOfCardToDraw
        
        if totalUsedCards <= Constants.Game.totalCard {
            for index in allotedCards.count..<noOfCell {
                let frame = newgrid[index]!
                let card = game.draw()
                let subFrame = view.convert(dealMoreButton.frame, to: cardGridView)
                let cardShow = CardView(frame: CGRect(x: subFrame.midX, y: subFrame.midY, width: frame.width, height: frame.height), card: card!, selected: false)
                addAnimation(withDelay: Constants.Game.delayBetweenCards, in: frame, on: cardShow)
                addGesture(on: cardShow)
                allotedCards.append(cardShow)
                cardGridView.addSubview(cardShow)
            }
        }
        grid = newgrid
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        resultLabel.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count - 1) CARDS NEEDED"
        if let cardView = sender.view as? CardView {
            if cardView.selected {
                if let index = selectedCards.firstIndex(of: cardView) {
                    selectedCards.remove(at: index)
                }
                game.deselectionPenalty()
                scoreCardChange()
                resultLabel.text = "\(Constants.Game.noOfCardToDraw - selectedCards.count) CARDS NEEDED"
            } else {
                selectedCards.append(cardView)
            }
            cardView.selected = !cardView.selected
        }
    }
}

