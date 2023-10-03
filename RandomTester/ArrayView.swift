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
    
    fileprivate var currentContext : CGContext? {
        get {
            if #available(OSX 10.10, *) {
                return NSGraphicsContext.current?.cgContext
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
    
    override func draw(_ rect: CGRect) {
        self.pointSize = self.bounds.width / 200
        if let context = self.currentContext {
            self.drawPoints(context)
        }
    }
    
    func drawPoints(_ context: CGContext) {
        context.setFillColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        for point in self.points {
            self.drawPoint(point, context: context)
        }
    }
    
    func drawPoint(_ point: CGPoint, context: CGContext) {
        let x = point.x * self.bounds.size.width
        let y = point.y * self.bounds.size.height
        
        let pointRect = CGRect(x: x, y: y, width: self.pointSize, height: self.pointSize)
        //        CGContextFillRect(context, pointRect)
        context.fillEllipse(in: pointRect)
    }
    
    func drawBackground(_ context: CGContext) {
        var ourRect = CGRect()
        context.setFillColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        ourRect.origin.x = 20
        ourRect.origin.y = 20
        ourRect.size.width = self.bounds.size.width - 40
        ourRect.size.height = self.bounds.size.height - 40
        context.fill(ourRect)
    }
    
}
