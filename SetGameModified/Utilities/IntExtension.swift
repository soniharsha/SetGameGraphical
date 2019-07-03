//
//  IntExtension.swift
//  SetGameModified
//
//  Created by Harsha on 28/06/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

extension Int {
    var random4arc: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
