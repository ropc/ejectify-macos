//
//  StatusBarController.swift
//  Ejectify
//
//  Created by Niels Mouthaan on 21/11/2020.
//

import AppKit

class StatusBar {
    
    private var statusItem: NSStatusItem
    private var unmountingPaths = Set<URL>()
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.menu = StatusBarMenu()

        updateButton()
    }
    
    private func setupNotificationObservers() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleUnmountNotification(_:)), name: NSWorkspace.willUnmountNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleUnmountNotification(_:)), name: NSWorkspace.didUnmountNotification, object: nil)
    }
    
    @objc
    private func handleUnmountNotification(_ notification: Notification) {
        guard let url = notification.userInfo?[NSWorkspace.volumeURLUserInfoKey] as? URL else {
            return
        }
        if notification.name == NSWorkspace.willUnmountNotification {
            unmountingPaths.insert(url)
        } else if notification.name == NSWorkspace.didUnmountNotification {
            unmountingPaths.remove(url)
        }
        updateButton()
    }
    
    private func updateButton() {
        guard let statusBarButton = statusItem.button else {
            return
        }
        statusBarButton.image = unmountingPaths.count == 0 ? NSImage(named: "StatusBarIcon") : NSImage(named: "eject")
        statusBarButton.image?.size = NSSize(width: 16.0, height: 16.0)
        statusBarButton.image?.isTemplate = true
    }
}
