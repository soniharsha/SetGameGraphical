//
//  Concentration.swift
//  Concentration
//
//  Created by Harsha on 07/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()

    private(set) var score = 0
    
    private var indexOfOneAndOnlyFaceUp: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
    private let date = Date()
    private lazy var lastTimeTouched = date.timeIntervalSinceNow
    
    func chooseCard(at index: Int) {
        //cards[index].isFaceUp = !cards[index].isFaceUp
        //including matchUp cases as well
        
        //only one card faceUp
        assert(cards.indices.contains(index), "error in chooseCards, index value \(index) is not correct")
        
        let curTime = date.timeIntervalSinceNow
        let dateDiff = Int(curTime - lastTimeTouched)
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUp, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score = score + 2 + dateDiff
                } else {
                    if cards[matchIndex].isSeen {
                        score = score - 1 + dateDiff
                    }
                    if cards[index].isSeen {
                        score = score - 1 + dateDiff
                    }
                }
                cards[matchIndex].isSeen = true
                cards[index].isSeen = true
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUp = index
            }
        }
        lastTimeTouched = curTime
    }
    
    func reset() {
        for index in cards.indices {
            cards[index].isSeen = false
        }
        score = 0
    }
    
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 1, "Not enough cards to start the game, error in init")
        var tempcards = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            tempcards += [card,card]
        }
        //shuffle the cards
        var remainingCard = 0
        for _ in 1...2 * numberOfPairsOfCards {
            let randomIndex = (2 * numberOfPairsOfCards - remainingCard).random4arc
            cards += [tempcards[randomIndex]]
            tempcards.remove(at: randomIndex)
            remainingCard = remainingCard + 1
        }
    }
}

