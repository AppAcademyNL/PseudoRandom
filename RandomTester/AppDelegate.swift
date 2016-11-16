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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openSobolWindow(_ sender: AnyObject)
    {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        self.sobolWC = sb.instantiateController(withIdentifier: "SobolWCID") as? NSWindowController
        self.sobolWC?.showWindow(self)
    }
    
}

