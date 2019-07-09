//
//  File.swift
//  Concentration
//
//  Created by Harsha on 14/06/19.
//  Copyright © 2019 ixigo. All rights reserved.
//

import Foundation

extension Int {
    var random4arc: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
