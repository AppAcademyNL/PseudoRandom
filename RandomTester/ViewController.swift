//
//  ViewController.swift
//  RandomTester
//
//  Created by Axel Roest on 09/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Cocoa

enum SliderTags : Int {
    case Uniform = 1
    case Pseudo = 2
}

class ViewController: NSViewController {
    @IBOutlet weak var uniformSlider: NSSlider!
    @IBOutlet weak var pseudoSlider: NSSlider!
    @IBOutlet weak var dotView: NSView!
    
    var gView : CGView?
    var count = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gView = CGView(frame: self.dotView.bounds)
        if let gView = gView {
//            gView.bounds = self.view.bounds
            self.dotView.addSubview(gView)
//            self.dotView.needsDisplay = true
            gView.points = self.generatePointCloudUniform(gView.bounds.size, count: count)
//            gView.haltonPoints = self.generatePointCloudHalton(gView.bounds.size, count: count)
            gView.haltonPoints = self.generatePointCloudSobol(gView.bounds.size, count: count)
            self.uniformSlider.doubleValue = gView.uniformTransparency
            self.pseudoSlider.doubleValue = gView.pseudoTransparency
        }
        self.view.needsDisplay = true
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
        let halton = HaltonRandom()
        
        for _ in 1...count {
            let point = halton.random(size)

//            let x = CGFloat(halton.random() * Double(size.width))
//            let y = CGFloat(halton.random() * Double(size.height))
//            let point = CGPointMake(x, y)
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
    
    @IBAction func setTransparency(sender: NSSlider) {
        let tag = SliderTags(rawValue: sender.tag)!
        switch tag {
        case .Uniform :
            self.gView?.uniformTransparency = sender.doubleValue
        case .Pseudo :
            self.gView?.pseudoTransparency = sender.doubleValue
        }
        if let g = self.gView {
            g.needsDisplay = true
        }
    }

}

class CGView : NSView {
    var uniformTransparency = 0.8
    var pseudoTransparency = 0.3

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
        CGContextSetRGBFillColor(context, 0.6, 0.0, 0.0, CGFloat(self.uniformTransparency))
        for point in self.points {
            self.drawPoint(point, context: context)
        }
    }
    
    func drawHaltonPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, CGFloat(self.pseudoTransparency))
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
