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
        var value: String {
            switch self {
            case .square: return "Square"
            case .circle: return "Circle"
            case .triangle: return "Triangle"
            }
        }
    }
    
    enum Shade: CaseIterable {
        case fill, outline, strip
        var value: String {
            switch self {
            case .fill: return "Fill"
            case .outline: return "Outline"
            case .strip: return "Strip"
            }
        }
    }
    
    enum Color: CaseIterable {
        case red, black, green
        var value: UIColor {
            switch self {
            case .red: return UIColor.red
            case .black: return UIColor.black
            case .green: return UIColor(red: 103/255, green: 179/255, blue: 45/255, alpha: 1)
            }
        }
    }
    
    enum Number:CGFloat, CaseIterable {
        case one = 1, two, three
    }
    
    var shape: Shape
    var color: Color
    var shade: Shade
    var number: Number
}

