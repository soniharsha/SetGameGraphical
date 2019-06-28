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
    
    mutating func draw() -> Card? {
        if cards.isEmpty { return nil }
        return cards.remove(at: cards.count.random4arc)
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
