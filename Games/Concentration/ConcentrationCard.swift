//
//  ConcentrationCard.swift
//  Concentration
//
//  Created by Harsha on 07/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

// opening braces on same line
struct ConcentrationCard {
    private(set) var identifier: Int

    var isFaceUp = false // space before and after operators
    var isMatched = false
    var isSeen = false
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}




