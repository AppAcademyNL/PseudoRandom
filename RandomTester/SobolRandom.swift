//
//  SobolRandom.swift
//  RandomTester
//
//  Created by Axel Roest on 10/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Foundation

class SobolRandom {
    var n: Int32 = 0
    var result : [Float] = [0,0,0,0]
    
    init() {
        n = -1
        sobseq(&n, &result)
        n = 0
    }
        
    func start(display: (UnsafePointer<UInt>, w: Int, h: Int) -> Void) {
        var nn : Int32 = -1
        sobseqBreakPoints(&nn, &result) { arr, width, height in
            // TODO: to prevent capturing, maybe we can *copy* the values from arr here into a new array?
//            let mem = UnsafePointer(arr)
            print ("w=\(width) x h=\(height)")
//            display(mem, w:width, h:height)
        }
        nn = 0
    }
    
    func random() -> CGPoint {
        n += 1
        sobseq(&n, &result)
        let x = CGFloat(result[1])
        let y = CGFloat(result[2])
        let point = CGPointMake(x, y)
        return point
    }
}