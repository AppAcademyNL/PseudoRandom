//
//  HaltonRandom.swift
//  RandomTester
//
//  Created by Axel Roest on 11/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

//https://en.wikipedia.org/wiki/Halton_sequence
//FUNCTION (index, base)
//BEGIN
//result = 0;
//f = 1;
//i = index;
//WHILE (i > 0)
//BEGIN
//f = f / base;
//result = result + f * (i % base);
//i = FLOOR(i / base);
//END
//RETURN result;
//END

import Foundation

class HaltonRandom {
    var index = 0
    let count : Int
    var haltonSequence : [CGPoint]
    
    init(count: Int) {
        self.count = count
        haltonSequence = [CGPoint]()
        for index in 1...count {
            let x = localHaltonSingleNumber(Double(index), base: Double(2))
            let y = localHaltonSingleNumber(Double(index), base: Double(3))
            
            haltonSequence.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        
    }
    
    convenience init() {
        self.init(count: 2200)
    }
    
    /* generates a two-dimensional sequence of count length */
    
    func random(_ dimension: CGSize) -> CGPoint {
        var point = self.random()
        point.x *= dimension.width
        point.y *= dimension.height
        return point
    }
    
    func random() -> CGPoint {
        if index < count {
            self.index += 1
            return haltonSequence[index]
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func localHaltonSingleNumber(_ index: Double, base: Double) -> Double {
        var result = 0.0
        var f = 1.0
        var n0 = index
        while (n0 > 0) {
            f = f / base
            result = result + f * (n0.truncatingRemainder(dividingBy: base))
            n0 = floor(n0 / base)
        }
        return result
    }
    
}

