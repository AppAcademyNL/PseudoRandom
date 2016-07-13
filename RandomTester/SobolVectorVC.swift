//
//  SobolVectorVC.swift
//  RandomTester
//
//  Created by Axel Roest on 13/07/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//


import Cocoa

class SobolVectorVC: NSViewController {
    @IBOutlet weak var arrayView: ArrayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.arrayView.needsDisplay = true
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
        if let g = self.self.arrayView {
            g.points = Array<CGPoint>()
            g.needsDisplay = true
        }
    }
    
    func generateSobolVector() {
        var points = [CGPoint]()
        let sobol = SobolRandom()
//        sobol.start() { arr, width, height in
//            print ("w=\(width) x h=\(height)")
//        }
        
    }
}
