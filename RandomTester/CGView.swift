//
//  CGView.swift
//  RandomTester
//
//  Created by Axel Roest on 13/07/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

/**
 Show the coordinates of the two-dimensional arrays of the various distributions
 in three transparent layers on top of each other
 
 **/

import Cocoa


class CGView : NSView {
    var uniformTransparency = 0.8
    var haltonTransparency = 0.4
    var sobolTransparency = 0.4
    var count = 2000
    
    var points : [CGPoint] = [] {
        didSet {
            self.needsDisplay = true
        }
    }
    var haltonPoints : [CGPoint] = [] {
        didSet {
            self.needsDisplay = true
        }
    }
    var sobolPoints : [CGPoint] = [] {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var pointSize : CGFloat = 2 {
        didSet {
            // pointSize = floor(pointSize)
            pointSize = pointSize < 2 ? 2 : pointSize
        }
    }
    
    private var currentContext : CGContext? {
        get {
            if #available(OSX 10.10, *) {
                return NSGraphicsContext.currentContext()?.CGContext
            } else if let contextPointer = NSGraphicsContext.currentContext()?.graphicsPort {
                let context: CGContextRef = Unmanaged.fromOpaque(COpaquePointer(contextPointer)).takeUnretainedValue()
                return context
            }
            
            return nil
        }
    }
    
    //    init(frameRect: NSRect) {
    //        super.init(frame: frameRect)
    //    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupArrays()
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.setupArrays()
    }
    
    func setupArrays() {
        self.points = self.generatePointCloudUniform(self.bounds.size, count: count)
        self.haltonPoints = self.generatePointCloudHalton(self.bounds.size, count: count)
        self.sobolPoints = self.generatePointCloudSobol(self.bounds.size, count: count)
    }
    
    override func drawRect(rect: CGRect) {
        self.pointSize = self.bounds.width / 200
        if let context = self.currentContext {
            self.drawUniformPoints(context)
            self.drawHaltonPoints(context)
            self.drawSobolPoints(context)
        }
    }
    
    func drawUniformPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.8, 0.0, 0.0, CGFloat(self.uniformTransparency))
        for point in self.points {
            self.drawPoint(point, context: context)
        }
    }
    
    func drawHaltonPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.1, 0.7, 0.2, CGFloat(self.haltonTransparency))
        for point in self.haltonPoints {
            self.drawPoint(point, context: context)
        }
    }
    func drawSobolPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, CGFloat(self.sobolTransparency))
        for point in self.sobolPoints {
            self.drawPoint(point, context: context)
        }
    }
    
    func drawPoint(point: CGPoint, context: CGContextRef) {
        let x = point.x * self.bounds.size.width
        let y = point.y * self.bounds.size.height
        
        let pointRect = CGRectMake(x, y, self.pointSize, self.pointSize)
        //        CGContextFillRect(context, pointRect)
        CGContextFillEllipseInRect(context, pointRect)
    }
    
    func drawBackground(context: CGContextRef) {
        var ourRect = CGRect()
        CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0)
        ourRect.origin.x = 20
        ourRect.origin.y = 20
        ourRect.size.width = self.bounds.size.width - 40
        ourRect.size.height = self.bounds.size.height - 40
        CGContextFillRect(context, ourRect)
    }
    
    // MARK: generate point clouds
    func generatePointCloudUniform(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        
        for _ in 1...count {
            let x = CGFloat(TLRandom())
            let y = CGFloat(TLRandom())
            let point = CGPointMake(x, y)
            points.append(point)
        }
        return points
    }
    
    func generatePointCloudHalton(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        let halton = HaltonRandom()
        
        for _ in 1...count {
            let point = halton.random()
            points.append(point)
        }
        return points
    }
    
    func generatePointCloudSobol(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        let sobol = SobolRandom()
        
        for _ in 1...count {
            let point = sobol.randomPoint()
            points.append(point)
        }
        return points
    }
    
}
