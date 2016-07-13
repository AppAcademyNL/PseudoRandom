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
    
    convenience init(callback:(UnsafePointer<Void>, Int, Int)) {
        self.init()
        n = -1
        sobseqBreakPoints(&n, &result) { arr, width, height in
            print ("w=\(width) x h=\(height)")
            
            }
        n = 0
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