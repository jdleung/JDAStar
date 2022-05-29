//
//  AppDelegate.swift
//  JDAStar_MacOS_Example
//
//  Created by jdleung on 2022/5/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        for win in NSApplication.shared.windows {
            win.setFrame(NSRect(x: 0, y: 0, width: 480, height: 800), display: true)
            win.center()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

