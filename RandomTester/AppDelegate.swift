//
//  AppDelegate.swift
//  RandomTester
//
//  Created by Axel Roest on 09/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var sobolWC : NSWindowController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func openSobolWindow(sender: AnyObject)
    {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        self.sobolWC = sb.instantiateControllerWithIdentifier("SobolWCID") as! NSWindowController
        self.sobolWC?.showWindow(self)
    }
    
}

