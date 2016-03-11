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

class HaltonRandom {
    var haltonSequence : Array<Double>
    var index = 0
    let count = 2200
    init() {
        haltonSequence = [Double]()
        for index in 1...count {
            let hn = localHaltonSingleNumber(Double(index), max: Double(count))
            haltonSequence.append(hn)
        }
    }
    
    func random(max: Double) -> Double {
        return self.random() * max
    }
    
    func random() -> Double {
        if index < count {
            self.index += 1
            return haltonSequence[index]
        }
        return 0
    }
    
    // doesn't seem to work. Probably misunderstood Matlab code
    func localHaltonSingleNumber(index: Double, max: Double) -> Double {
        var n0 = index
        var hn : Double = 0.0
        var f = 1/max
        while (n0 > 0) {
            let n1 = n0 / max
            let r = n0 - n1 * max
            hn = hn + f * r
            f = f / max
            n0 = n1
        }
        return hn
    }
}

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

//for idx = 1:n
//hs(idx) = localHaltonSingleNumber(idx,b);
//end
//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//% Subfunction to generate the nth number in Halton's sequence
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
//function hn = localHaltonSingleNumber(n,b)
//% This function generates the n-th number in Halton's low
//% discrepancy sequence.
//n0 = n;
//hn = 0;
//f = 1/b;
//while (n0>0)
//n1 = floor(n0/b);
//r = n0-n1*b;
//hn = hn + f*r;
//f = f/b;
//n0 = n1;
//end