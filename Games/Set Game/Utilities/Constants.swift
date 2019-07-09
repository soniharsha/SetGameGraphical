//
//  Constants.swift
//  SetGameModified
//
//  Created by Harsha on 27/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

struct Constants {
    struct Game {
        static let initialRow = 4
        static let initialColumn = 3
        static let noOfCardToDraw = 3
        static let pointEarnedForSet = 3
        static let totalCard = 81
        static let loadCardDuration = 1.0
        static let delayBetweenCards = 0.1
        static let scoreCardTextSize = 20
        static let scoreCardAnimatedSize = 30
    }
    struct Color {
        static let backgroundColor = UIColor.white
        static let fontColor = UIColor.black
    }
    struct Penalties {
        static let deselectionPenalty = -1
        static let wrongSetFormationPenalty = -5
        static let moreCardsShowPenalty = -5
    }
}




