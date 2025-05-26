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
    // 登録済みビューの追跡にUUIDを使用
    private static var registeredViews = [UUID: SwiftUIView]()
    
    // 登録時に一意のIDを返す
    @discardableResult
    static func registerView(_ view: SwiftUIView) -> UUID {
        let id = UUID()
        print("iOS: Registering SwiftUIView with ID: \(id)")
        registeredViews[id] = view
        
        // 最初のビューが登録されたときだけ通知を設定
        if registeredViews.count == 1 {
            setupNotifications()
        }
        
        // 登録済みのビューの数をログ出力
        print("iOS: Total registered views: \(registeredViews.count)")
        return id
    }
    
    // IDを使って登録解除
    static func unregisterView(with id: UUID) {
        print("iOS: Unregistering SwiftUIView with ID: \(id)")
        registeredViews.removeValue(forKey: id)
        
        // 登録済みビューがなくなったら通知登録を解除
        if registeredViews.isEmpty {
            print("iOS: No more views registered, removing notifications")
            removeNotifications()
        } else {
            print("iOS: Remaining registered views: \(registeredViews.count)")
        }
    }
    
    // 通知セットアップ（クラスレベルで一度だけ）
    private static func setupNotifications() {
        print("iOS: Setting up notification observer for FetchAds")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: NSNotification.FetchAds,
            object: nil
        )
    }
    
    // 通知登録解除
    private static func removeNotifications() {
        print("iOS: Removing notification observer")
        NotificationCenter.default.removeObserver(self)
    }
    
    // 通知ハンドラー
    @objc static func handleNotification(_ notification: Notification) {
        print("iOS: Received FetchAds notification, will update \(registeredViews.count) views")
        
        // 全ての登録済みビューに通知
        DispatchQueue.main.async {
            for (id, view) in registeredViews {
                print("iOS: Updating view with ID: \(id)")
                view.loadAds()
            }
        }
    }
} 
