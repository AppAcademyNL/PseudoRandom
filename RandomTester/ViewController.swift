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
    case Halton = 2
    case Sobol = 3
}

class ViewController: NSViewController {
    @IBOutlet weak var uniformSlider: NSSlider!
    @IBOutlet weak var haltonSlider: NSSlider!
    @IBOutlet weak var sobolSlider: NSSlider!
    @IBOutlet weak var dotView: CGView!
    
//    var gView : CGView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gView = CGView(frame: self.dotView.bounds)
        if self.dotView != nil {
            // self.dotView.addSubview(gView)
            self.uniformSlider.doubleValue = self.dotView.uniformTransparency
            self.haltonSlider.doubleValue = self.dotView.haltonTransparency
            self.sobolSlider.doubleValue = self.dotView.sobolTransparency
        }
        self.dotView.needsDisplay = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let win = self.view.window {
            win.title = "Random Distributions"
        }
    }
    
    @IBAction func setTransparency(sender: NSSlider) {
        let tag = SliderTags(rawValue: sender.tag)!
        switch tag {
        case .Uniform :
            self.self.dotView?.uniformTransparency = sender.doubleValue
        case .Halton :
            self.self.dotView?.haltonTransparency = sender.doubleValue
        case .Sobol :
            self.self.dotView?.sobolTransparency = sender.doubleValue
        }
        if let g = self.self.dotView {
            g.needsDisplay = true
        }
    }

}
