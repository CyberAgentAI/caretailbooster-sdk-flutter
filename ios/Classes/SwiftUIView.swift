import Flutter
import UIKit
import SwiftUI
import CaRetailBoosterSDK

class SwiftUIView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let channel: FlutterMethodChannel
    private var retailBoosterAd: RetailBoosterAd
    private let hostingController: UIHostingController<AnyView>
    private let itemSpacing: CGFloat?
    private let leadingMargin: CGFloat?
    private let trailingMargin: CGFloat?
    private let hiddenIndicators: Bool
    // 通知登録のためのID
    private var notificationId: UUID?

    @MainActor
    init(
        frame: CGRect,
        messenger: FlutterBinaryMessenger,
        viewId: Int64,
        mediaId: String,
        userId: String,
        crypto: String,
        tagGroupId: String,
        runMode: String,
        width: Int?,
        height: Int?,
        itemSpacing: CGFloat?,
        leadingMargin: CGFloat?,
        trailingMargin: CGFloat?,
        hiddenIndicators: Bool
    ) {
        print("iOS: SwiftUIView init with viewId: \(viewId)")
        
        channel = FlutterMethodChannel(name: "ca_retail_booster_ad_view_\(viewId)", binaryMessenger: messenger)
        weak var weakChannel = channel

        hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        hostingController.view.frame = frame
        hostingController.view.backgroundColor = .clear

        _view = hostingController.view
        
        self.itemSpacing = itemSpacing
        self.leadingMargin = leadingMargin
        self.trailingMargin = trailingMargin
        self.hiddenIndicators = hiddenIndicators

        // コールバックの初期化
        let callback = Callback(
            onMarkSucceeded: {
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.markSucceeded.rawValue, arguments: nil)
            },
            onRewardModalClosed: {
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.rewardModalClosed.rawValue, arguments: nil)
            }
        )
        
        // RetailBoosterAdの初期化
        retailBoosterAd = RetailBoosterAd(
            mediaId: mediaId,
            userId: userId,
            crypto: crypto,
            tagGroupId: tagGroupId,
            mode: .init(rawValue: runMode) ?? .stg,
            callback: callback,
            options: .init(rewardAd: RewardAdOption(
                    width: width,
                    height: height
                )
            )
        )

        super.init()
        
        // 通知システムに登録して、IDを保存
        notificationId = SwiftUIViewNotification.registerView(self)
        
        loadAds()
    }
    
    // 広告データの読み込みメソッド
    @MainActor
    func loadAds() {
        print("iOS: loadAds called for SwiftUIView with ID: \(notificationId?.uuidString ?? "unknown")")
        
        weak var weakChannel = channel
        
        self.retailBoosterAd.getAdViews { [weak self] result in
            guard let self = self else { return }
            
            if case .success(let adViews) = result, !adViews.isEmpty {
                print("iOS: Successfully loaded \(adViews.count) ads")
                
                DispatchQueue.main.async {
                    let adScrollView = ScrollView(.horizontal, showsIndicators: self.hiddenIndicators) {
                        HStack(spacing: self.itemSpacing ?? 0) {
                            if let leadingMargin = self.leadingMargin, leadingMargin > 0 {
                                Spacer()
                                    .frame(width: leadingMargin)
                            }
                            ForEach(0..<adViews.count, id: \.self) { index in
                                adViews[index]
                            }
                            if let trailingMargin = self.trailingMargin, trailingMargin > 0 {
                                Spacer()
                                    .frame(width: trailingMargin)
                            }
                        }
                    }
                    print("iOS: Updating UI with new ads")
                    self.hostingController.rootView = AnyView(adScrollView)
                }
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: true)
            } else {
                print("iOS: No ads available or error occurred")
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: false)
            }
        }
    }

    func view() -> UIView {
        _view
    }
    
    deinit {
        print("iOS: SwiftUIView deinit with ID: \(notificationId?.uuidString ?? "unknown")")
        
        // IDを使って通知登録を解除
        if let id = notificationId {
            SwiftUIViewNotification.unregisterView(with: id)
        }
    }
}
