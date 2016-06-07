//
//  CategoryBitMasks.swift
//  _zero
//
//  Created by Jake Johnson on 4/19/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import Foundation

struct CategoryBitMasks {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Coin   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10   // 2
    static let Hero: UInt32 = 0b11         // 3
}