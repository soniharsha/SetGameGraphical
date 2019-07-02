//
//  CardDeck.swift
//  SetGameModified
//
//  Created by Harsha on 28/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var cards = [Card]()
    private(set) var score = 0
    private let date = Date()
    private lazy var lastNotedTime = date.timeIntervalSinceNow
    
    mutating func draw() -> Card? {
        if cards.isEmpty { return nil }
        return cards.remove(at: cards.count.random4arc)
    }
    
    mutating func containsSet(in setOf: [Card]) -> Bool {
        let curTime = date.timeIntervalSinceNow
        let firstCard = setOf[0], secondCard = setOf[1], thirdCard = setOf[2]
        
        guard (firstCard.shape == secondCard.shape && secondCard.shape == thirdCard.shape && firstCard.shape == thirdCard.shape) || (firstCard.shape != secondCard.shape && secondCard.shape != thirdCard.shape && firstCard.shape != thirdCard.shape) else {
            return false;
        }
        
        guard (firstCard.color == secondCard.color && secondCard.color == thirdCard.color && firstCard.color == thirdCard.color) || (firstCard.color != secondCard.color && secondCard.color != thirdCard.color && firstCard.color != thirdCard.color) else {
            return false;
        }
        guard (firstCard.shade == secondCard.shade && secondCard.shade == thirdCard.shade && firstCard.shade == thirdCard.shade) || (firstCard.shade != secondCard.shade && secondCard.shade != thirdCard.shade && firstCard.shade != thirdCard.shade) else {
            return false;
        }
        guard (firstCard.number == secondCard.number && secondCard.number == thirdCard.number && firstCard.number == thirdCard.number) || (firstCard.number != secondCard.number && secondCard.number != thirdCard.number && firstCard.number != thirdCard.number) else {
            return false;
        }
        score = score + Constants.Game.pointEarnedForSet + Int(0.01 * (curTime - lastNotedTime))
        return true
    }
    
    init() {
        for shape in Card.Shape.allCases {
            for color in Card.Color.allCases {
                for shade in Card.Shade.allCases {
                    for number in Card.Number.allCases {
                        cards.append(Card(shape: shape, color: color, shade: shade, number: number))
                    }
                }
            }
        }
        cards.shuffle()
    }
}
