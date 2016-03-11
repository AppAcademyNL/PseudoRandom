//
//  RandomUtils.swift
//  RandomTester
//
//  Created by Axel Roest on 09/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Foundation

func TLRandom(max: Int) -> Int {
    let r = Int(arc4random())
    return r % max
}

func TLRandom() -> Double {
    let r = Double(arc4random())
    return r / Double(UInt32.max)
}
