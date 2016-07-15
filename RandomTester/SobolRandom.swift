//
//  SobolRandom.swift
//  RandomTester
//
//  Created by Axel Roest on 10/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Foundation

class SobolRandom {
    var sobolIndex: Int32 = 0
    var result : [Float] = [0,0,0,0]
    
    // new Sobol from C vars
    let MaxDim = 6
    let MaxBit = 30                 // 32 bits minus error margin
    
    var fac : Double = 0.0
//    var in : UInt32
    var ix : ContiguousArray<UInt32> =    [0,0,0,0,0,0,0]
    var initUnit : ContiguousArray<UInt32>
    var mdeg : ContiguousArray<UInt32> =  [0,1,2,3,3,4,4]
    var ip : ContiguousArray<UInt32> =    [0,0,1,1,2,1,4]
    var initVector : ContiguousArray<ContiguousArray<UInt32>>       // [0,1,1,1,1,1,1,3,1,3,3,1,1,5,7,7,3,3,5,15,11,5,15,13,9]

    
    init() {
        sobolIndex = -1
        sobseq(&sobolIndex, &result)
        sobolIndex = 0
        
        // Swift Sobol init
        ix = ContiguousArray<UInt32>()
        ix.reserveCapacity(MaxDim + 1)
        
        initUnit = ContiguousArray<UInt32>()
        initUnit.reserveCapacity(Int(MaxBit + 1))
        
        initVector = ContiguousArray(count: MaxBit, repeatedValue: ContiguousArray(count: MaxDim, repeatedValue: 0))
        initVector[0] = [0,1,1,1,1,1]
        initVector[1] = [1,3,1,3,3,1]
        initVector[2] = [1,5,7,7,3,3]
        initVector[3] = [5,15,11,5,15,13]
        initVector[4] = [9,0,0,0,0,0]
        
        prepareSobol()
    }
    
    func prepareSobol() {
        var i : UInt32
        var j, k, l : Int
        var ipp : UInt32
//        var inloop = 0
//        assert(initVector[1] == 1,"Initialisation vector is incorrect")
        self.fac = 1.0/Double((UInt32(1) << UInt32(MaxBit)))
        
        l = 0
        
        // initialise iu array
        k = 0
        //        for j in (1 ... Int(MaxBit)) {
        ////            iu[j] = &initVector[k]
        //            k += MaxDim
        //        }
        
        // initialise iu array some more
        for k in (1...MaxDim) {
            for j in (1 ... Int(mdeg[k])) {
//                initVector[j][k] <<= Int32(MaxBit - j)
                let workaround = initVector[j][k]
                initVector[j][k] = workaround << UInt32(MaxBit - j)
            }
            let startJ = Int(mdeg[k]+1)
            for j in (startJ ... MaxBit) {
                ipp = ip[k]
                i = initVector[j-Int(mdeg[k])][k]
                i ^= (i >> mdeg[k])
                let startL = Int(mdeg[k]) - 1
                for l in (1 ... startL).reverse() {
                    if (ipp & 1) == 1 {
                        i ^= initVector[j-l][k]
                    }
                    ipp >>= 1
                }
                initVector[j][k] = i
            }
        }
    }
    
    // return the next value of the random values
    func sobol() {
        var im = Int(sobolIndex) + 1
        var jj: Int = 0

        var result = Array<Double>()
        result[0] = 0
        
        for j in (1 ... MaxBit) {        //        Find the rightmost zero bit.
            if (im & 1) == 0 {
                jj = j
                break
            }
            im >>= 1
        }
        
        assert(jj < MaxBit, "MAXBIT too small in sobseq")
        
        im = (jj-1) * MaxDim
        //         XOR the appropriate direction number into each component of the vector and convert to a floating number.

        let endK = min( Int(sobolIndex), y:MaxDim)
        for k in (1 ... endK) {
            ix[k] ^= initVector[k][im]
            result[k] = Double(ix[k]) * fac
        }
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
        sobolIndex += 1
        sobseq(&sobolIndex, &result)
        let x = CGFloat(result[1])
        let y = CGFloat(result[2])
        let point = CGPointMake(x, y)
        return point
    }
    
    func randomPoint() -> CGPoint {
        sobolIndex += 1       // I guess n needs to be 2 for a two dimensional vector
        sobseq(&sobolIndex, &result)
        let x = CGFloat(result[1])
        let y = CGFloat(result[2])
        let point = CGPointMake(x, y)
        
        // logging
        //        if (n % 100) == 0 {
        //            NSLog("RandomPoint called: %d times", n)
        //        }
        return point
    }

    func min<T : Comparable>(x:T , y:T) -> T {
        return (x < y) ? x : y
    }
}