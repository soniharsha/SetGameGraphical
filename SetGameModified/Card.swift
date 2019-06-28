//
//  Card.swift
//  SetGameModified
//
//  Created by Harsha on 26/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation
import UIKit

struct Card {
    enum Shape: CaseIterable {
        case square, circle, triangle
    }
    
    enum Shade: CaseIterable {
        case fill, outline, strip
    }
    
    enum Color: CaseIterable {
        case red, black, green
    }
    
    enum Number: CaseIterable {
        case one, two, three
    }
    
    var shape: Shape
    var color: Color
    var shade: Shade
    var number: Number
}

