//
//  ViewController.swift
//  RandomTester
//
//  Created by Axel Roest on 09/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Cocoa

enum SliderTags : Int {
    case uniform = 1
    case halton = 2
    case sobol = 3
}

class ViewController: NSViewController {
    @IBOutlet weak var uniformSlider: NSSlider!
    @IBOutlet weak var haltonSlider: NSSlider!
    @IBOutlet weak var sobolSlider: NSSlider!
    @IBOutlet weak var dotView: CGView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.dotView != nil {
            self.uniformSlider.doubleValue = self.dotView.uniformTransparency
            self.haltonSlider.doubleValue = self.dotView.haltonTransparency
            self.sobolSlider.doubleValue = self.dotView.sobolTransparency
        }
        self.dotView.needsDisplay = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let win = self.view.window {
            win.title = "Random Distributions"
        }
    }
    
    @IBAction func setTransparency(_ sender: NSSlider) {
        let tag = SliderTags(rawValue: sender.tag)!
        switch tag {
        case .uniform :
            self.self.dotView?.uniformTransparency = sender.doubleValue
        case .halton :
            self.self.dotView?.haltonTransparency = sender.doubleValue
        case .sobol :
            self.self.dotView?.sobolTransparency = sender.doubleValue
        }
        if let g = self.self.dotView {
            g.needsDisplay = true
        }
    }

}
