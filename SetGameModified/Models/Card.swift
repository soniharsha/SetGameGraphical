//
//  Card.swift
//  SetGameModified
//
//  Created by Harsha on 26/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation
import UIKit

struct Card: Equatable {
    
    enum Shape: CaseIterable {
        case square, circle, triangle
        
        var value: String {
            switch self {
            case .square: return "Square"
            case .circle: return "Circle"
            case .triangle: return "Star"
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
    
    enum Number: CaseIterable {
        case one, two, three
        
        var value: CGFloat {
            switch self {
            case .one: return 1
            case .two: return 2
            case .three: return 3
            }
        }
    }
    
    var shape: Shape
    var color: Color
    var shade: Shade
    var number: Number
    
}

