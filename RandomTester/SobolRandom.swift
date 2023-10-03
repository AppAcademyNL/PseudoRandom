//
//  SobolRandom.swift
//  RandomTester
//
//  Created by Axel Roest on 10/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//
/* Interface between Sobol pseudo-random generator in C and swift */

import Foundation

class SobolRandom {
    var sinit: Int32 = 0                // for C
    var sobolIndex: Int = 0           // for swift
    
    var result : [Float] = [0,0,0,0]
    
    // new Sobol from C vars
    let MaxDim = 6
    let MaxBit = 30                 // 32 bits minus error margin
    
    var fac : Double = 0.0

    var ix : ContiguousArray<UInt32> =    [0,0,0,0,0,0]
    var mdeg : ContiguousArray<UInt32> =  [1,2,3,3,4,4]
    var ip : ContiguousArray<UInt32> =    [0,1,1,2,1,4]
    var initVector : ContiguousArray<ContiguousArray<UInt32>>       // [0,1,1,1,1,1,1,3,1,3,3,1,1,5,7,7,3,3,5,15,11,5,15,13,9]

    
    init() {
        sinit = -1
        sobseq(&sinit, &result)
        sinit = 0
        
        // Swift Sobol init
        
        initVector = ContiguousArray(repeating: ContiguousArray(repeating: 0, count: MaxDim), count: MaxBit)      // we should move to zero index

        initVector[0] = [1,1,1,1,1,1]
        initVector[1] = [3,1,3,3,1,1]
        initVector[2] = [5,7,7,3,3,5]
        initVector[3] = [15,11,5,15,13,9]

//        initVector[0] = [0,1,1,1,1,1]
//        initVector[1] = [1,3,1,3,3,1]
//        initVector[2] = [1,5,7,7,3,3]
//        initVector[3] = [5,15,11,5,15,13]
//        initVector[4] = [9,0,0,0,0,0]
        
        prepareSobol()
    }
    
    func prepareSobol() {
        assert(initVector[0][1] == UInt32(1),"Initialisation vector is incorrect")
        self.fac = 1.0 / Double( UInt32(1) << UInt32(MaxBit) )
        
        // initialise iu array
        //        for j in (1 ... Int(MaxBit)) {
        ////            iu[j] = &initVector[k]
        //            k += MaxDim
        //        }
        
        // initialise iu array some more
        for k in (0 ..< MaxDim) {
            for j in (0 ..< Int(mdeg[k])) {
//                initVector[j][k] <<= Int32(MaxBit - j)
                let workaround = initVector[j][k]
                initVector[j][k] = workaround << UInt32(MaxBit - j - 1)
            }
            let startJ = Int(mdeg[k])
            for j in (startJ ..< MaxBit) {
                var ipp : UInt32 = ip[k]
                var i : UInt32 = initVector[j-Int(mdeg[k])][k]
                i ^= (i >> mdeg[k])
                let startL = Int((mdeg[k] - 1)) // - 1
                if startL >= 1 {
                    for l in (1 ... startL).reversed() {
                        if (ipp & 1) == 1 {
                            i ^= initVector[j-l ][k]
                        }
                        ipp >>= 1
                    }
                }
                initVector[j][k] = i
            }
        }
        print("swift index\tim\tx[0]\tx[1]\tx[2]")
    }
    
    // return the next value of the random values
    func sobol(_ sIndex : Int) -> ContiguousArray<Double> {
        var im = sIndex
        var jj: Int = 0

        var result = ContiguousArray<Double>(repeating: 0, count: MaxDim)
        
        for j in (0 ..< MaxBit) {        //        Find the rightmost zero bit.
            if (im & 1) == 0 {
                jj = j
                break
            }
            im >>= 1
        }
        
        assert(jj < MaxBit, "MAXBIT too small in sobseq")
        
        //         XOR the appropriate direction number into each component of the vector and convert to a floating number.

        let endK = min( Int(sIndex), y:(MaxDim - 1))
        for k in (0 ... endK) {
            ix[k] ^= initVector[jj][k]
            result[k] = Double(ix[k]) * fac
        }
        print("\(sIndex+1)\t\(im)\t\(result[0])\t\(result[1])\t\(result[2])")
        return result
    }


    func start(_ display: (UnsafePointer<UInt>, _ w: Int, _ h: Int) -> Void) {
        var nn : Int32 = -1
        sobseqBreakPoints(&nn, &result) { arr, width, height in
            // TODO: to prevent capturing, maybe we can *copy* the values from arr here into a new array?
//            let mem = UnsafePointer(arr)
            print ("w=\(width) x h=\(height)")
//            display(mem, w:width, h:height)
        }
        nn = 0
    }
    
    func randomPointC() -> CGPoint {
        sinit += 1       // I guess n needs to be 2 for a two dimensional vector
        sobseq(&sinit, &result)
        let x = CGFloat(result[1])
        let y = CGFloat(result[2])
        let point = CGPoint(x: x, y: y)
        
        // logging
//        if (n % 100) == 0 {
//            NSLog("RandomPoint called: %d times", n)
//        }
        return point
    }

    func seedRandom() {
        self.sobolIndex = TLRandom(128)
    }
    
    func randomPoint() -> CGPoint {
        sobolIndex += 1       // I guess n needs to be 2 for a two dimensional vector
        let result = self.sobol(sobolIndex)
        let x = CGFloat(result[0])
        let y = CGFloat(result[1])
        let point = CGPoint(x: x, y: y)
        
        // logging
        //        if (n % 100) == 0 {
        //            NSLog("RandomPoint called: %d times", n)
        //        }
        return point
    }

    func min<T : Comparable>(_ x:T , y:T) -> T {
        return (x < y) ? x : y
    }
}
