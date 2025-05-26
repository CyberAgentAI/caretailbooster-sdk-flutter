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
    private static var viewsByTagGroup = [String: WeakReference<SwiftUIView>]()
    private static var isDebouncing = false
    
    private class WeakReference<T: AnyObject> {
        weak var target: T?
        init(_ target: T) { self.target = target }
    }
    
    static func registerView(_ view: SwiftUIView, tagGroupId: String) {
        viewsByTagGroup[tagGroupId] = WeakReference(view)
        
        if viewsByTagGroup.count == 1 {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification),
                name: NSNotification.FetchAds,
                object: nil
            )
        }
    }
    
    static func unregisterView(_ view: SwiftUIView, tagGroupId: String) {
        if let ref = viewsByTagGroup[tagGroupId], ref.target === view {
            viewsByTagGroup.removeValue(forKey: tagGroupId)
        }
        
        if viewsByTagGroup.isEmpty {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc static func handleNotification(_ notification: Notification) {
        if isDebouncing { return }
        isDebouncing = true
        
        DispatchQueue.main.async {
            for (group, ref) in viewsByTagGroup where ref.target != nil {
                ref.target?.loadAds()
            }
            
            viewsByTagGroup = viewsByTagGroup.filter { $0.value.target != nil }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isDebouncing = false
            }
        }
    }
} 
