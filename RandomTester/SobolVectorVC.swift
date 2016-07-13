//
//  SobolVectorVC.swift
//  RandomTester
//
//  Created by Axel Roest on 13/07/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//


import Cocoa

class SobolVectorVC: NSViewController {
    @IBOutlet weak var dotView: ArrayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dotView.needsDisplay = true
        // Do any additional setup after loading the view.
        self.generateSobolVector()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let win = self.view.window {
            win.title = "Sobol Init Vector"
        }
    }
    
    @IBAction func step(sender: NSButton) {
        if let g = self.self.dotView {
            g.vector = 
            g.needsDisplay = true
        }
    }
    
    func generateSobolVector() {
        var points = [CGPoint]()
        let sobol = SobolRandom() { arr, width, height in
            print ("w=\(width) x h=\(height)")
        }
        
        for _ in 1...count {
            let point = sobol.random()
            points.append(point)
        }
        return points
    }
}
