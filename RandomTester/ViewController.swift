//
//  ViewController.swift
//  RandomTester
//
//  Created by Axel Roest on 09/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var gView : CGView?
    var count = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gView = CGView(frame: self.view.bounds)
        if let gView = gView {
//            gView.bounds = self.view.bounds
            self.view.addSubview(gView)
            self.view.needsDisplay = true
            gView.points = self.generatePointCloudUniform(gView.bounds.size, count: count)
//            gView.haltonPoints = self.generatePointCloudHalton(gView.bounds.size, count: count)
            gView.haltonPoints = self.generatePointCloudSobol(gView.bounds.size, count: count)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let win = self.view.window {
            win.title = "Uniform Random"
        }
    }
    func generatePointCloudUniform(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        
        for _ in 1...count {
            let x = CGFloat(TLRandom(Int(size.width)))
            let y = CGFloat(TLRandom(Int(size.height)))
            let point = CGPointMake(x, y)
            points.append(point)
        }
        return points
    }
    
    func generatePointCloudHalton(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        let halton = Halton()
        
        for _ in 1...count {
            let x = CGFloat(halton.random() * Double(size.width))
            let y = CGFloat(halton.random() * Double(size.height))
            let point = CGPointMake(x, y)
            points.append(point)
        }
        return points
    }
    
    func generatePointCloudSobol(size: CGSize, count: Int) -> Array<CGPoint> {
        var points = [CGPoint]()
        let sobol = SobolRandom()
        
        for _ in 1...count {
            var point = sobol.random()
            point.x *= size.width
            point.y *= size.height
//            let x = CGFloat(sobol.random() * )
//            let y = CGFloat(sobol.random() * Double(size.height))
//            let point = CGPointMake(x, y)
            points.append(point)
        }
        return points
    }

}

class CGView : NSView {
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
    let pointSize : CGFloat = 2
    
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

//    
//    init(frameRect: NSRect) {
//        super.init(frame: frameRect)
//    }
//    
    override func drawRect(rect: CGRect) {
        if let context = self.currentContext {
            self.drawUniformPoints(context)
            self.drawHaltonPoints(context)
        }
    }
    
    func drawUniformPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.6, 0.0, 0.0, 1.0)
        for point in self.points {
            self.drawPoint(point, context: context)
        }
    }
    
    func drawHaltonPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0)
        for point in self.haltonPoints {
            self.drawPoint(point, context: context)
        }
    }

    func drawPoint(point: CGPoint, context: CGContextRef) {
        let pointRect = CGRectMake(point.x, point.y, self.pointSize, self.pointSize)
        CGContextFillRect(context, pointRect)
        
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
}
