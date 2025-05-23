import Foundation
import UIKit
import SwiftUI
import CaRetailBoosterSDK
import Flutter

extension NSNotification {
    // iOS SDKと通知の名前を合わせる
    static let FetchAds = Notification.Name("FetchAds")
}

class SwiftUIViewNotification {
    private static var swiftUIView: SwiftUIView?

    public static func setSwiftUIView(_ view: SwiftUIView) {
        swiftUIView = view
    }
    
    static func registerNotifications() {
        let notificationTypes: [Notification.Name] = [
            NSNotification.FetchAds
        ]
        
        for notificationType in notificationTypes {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification(_:)),
                name: notificationType,
                object: nil
            )
        }
    }
    
    static func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc static func handleNotification(_ notification: Notification) {
        switch notification.name {
        case NSNotification.FetchAds:
            handleFetchAdsNotification(notification)
        default:
            print("Unknown notification: \(notification.name)")
        }
    }
    
    private static func handleFetchAdsNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.swiftUIView?.loadAds()
        }
    }
} 
