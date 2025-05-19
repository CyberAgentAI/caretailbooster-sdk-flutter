import Flutter
import UIKit
import SwiftUI
import CaRetailBoosterSDK

class SwiftUIView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let channel: FlutterMethodChannel
    private var retailBoosterAd: RetailBoosterAd

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
        channel = FlutterMethodChannel(name: "ca_retail_booster_ad_view_\(viewId)", binaryMessenger: messenger)
        weak var weakChannel = channel

        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        hostingController.view.frame = frame
        hostingController.view.backgroundColor = .clear

        _view = hostingController.view

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
            callback: callback
        )

        super.init()

        // 広告を読み込んで表示
        self.retailBoosterAd.getAdViews { result in
            if case .success(let adViews) = result, !adViews.isEmpty {
                DispatchQueue.main.async {
                    let adScrollView = ScrollView(.horizontal, showsIndicators: hiddenIndicators) {
                        HStack(spacing: itemSpacing ?? 0) {
                            if let leadingMargin, leadingMargin > 0 {
                                Spacer()
                                    .frame(width: leadingMargin)
                            }
                            ForEach(0..<adViews.count, id: \.self) { index in
                                adViews[index]
                            }
                            if let trailingMargin, trailingMargin > 0 {
                                Spacer()
                                    .frame(width: trailingMargin)
                            }
                        }
                    }
                    hostingController.rootView = AnyView(adScrollView)
                }
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: true)
            } else {
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: false)
            }
        }
    }

    func view() -> UIView {
        _view
    }
}