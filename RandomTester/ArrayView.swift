//
//  ArrayView.swift
//  RandomTester
//
//  Created by Axel Roest on 13/07/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//


/**
 Show the values of the two-dimensional array in multicolour in the view
 
 **/
import Cocoa


class ArrayView : NSView {
    var count = 2000
    
    var points : [CGPoint] = [] {
        didSet {
            self.needsDisplay = true
        }
    }
    var mywidth : Int
    var myheight : Int
    
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
        self.mywidth = 10
        self.myheight = 20
        super.init(coder: coder)
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
//        self.setupArrays()
    }
    
    override func drawRect(rect: CGRect) {
        self.pointSize = self.bounds.width / 200
        if let context = self.currentContext {
            self.drawPoints(context)
        }
    }
    
    func drawPoints(context: CGContextRef) {
        CGContextSetRGBFillColor(context, 0.8, 0.0, 0.0, 1.0)
        for point in self.points {
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
    
}
